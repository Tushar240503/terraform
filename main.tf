provider "aws" {
    region  = "ap-south-1"
    access_key = var.access
    secret_key = var.secret_key
}
  resource "aws_vpc" "my-app-vpc"{
    cidr_block=var.vpc_cidr
    tags={
      Name: "${var.env_prefix}-vpc"

    }
  } 
   resource "aws_subnet" "my-app-subnet-1"{
    vpc_id=aws_vpc.my-app-vpc.id
    cidr_block=var.subnet_cidr
    availability_zone=var.avail_zone
    tags={
      Name: "${var. env_prefix}-subent-1"
    }
   }
   resource "aws_route_table" "myapp-route-table"{
     vpc_id=aws_vpc.my-app-vpc.id
     route{
         cidr_block= "0.0.0.0/0"
         gateway_id=aws_internet_gateway.myapp-gateway.id 
     }
     tags={
          Name: "${var.env_prefix}-table"
     }

   }
   resource "aws_internet_gateway" "myapp-gateway"{
      vpc_id=aws_vpc.my-app-vpc.id
      tags={
          Name: "${var.env_prefix}-gateway"
     }
   }
    resource "aws_route_table_association" "ass"{
      subnet_id=aws_subnet.my-app-subnet-1.id
      route_table_id=aws_route_table.myapp-route-table.id
       
    }
     resource "aws_security_group" "sg"{
      name= "sg"
      vpc_id=aws_vpc.my-app-vpc.id

      ingress {
        from_port=22
        to_port=22
        protocol= "tcp"
        cidr_blocks=["0.0.0.0/0"]
      }
      ingress {
        from_port=8080
        to_port=8080
        protocol= "tcp"
        cidr_blocks=["0.0.0.0/0"]
      }
      egress {
         from_port=0
        to_port=0
        protocol= "-1 "
        cidr_blocks=["0.0.0.0/0"]
      }
      tags={
          Name: "${var.env_prefix}-sg"
     }

     }
     data "aws_ami" "latest"{
        most_recent=true
        owners=["amazon"]
        filter {
          name= "name"
          values =["amzn2-ami-hvm-*-x86_64-gp2"]
        }
        filter {
            name = "virtualization-type"
            values =["hvm"]
        }
     }
     resource "aws_key_pair" "key" {
        key_name= "server-key"
        public_key="${file("/Users/tusharsharma/.ssh/id_rsa.pub")}"
     }

     resource "aws_instance" "my-app-server"{
      ami =data.aws_ami.latest.id
      instance_type="t2.micro"
      subnet_id=aws_subnet.my-app-subnet-1.id
      vpc_security_group_ids=[aws_security_group.sg.id]
      availability_zone=var.avail_zone
      associate_public_ip_address=true
      key_name="aws_key_pair.key.key_name"
       user_data = file("entry-script.sh")
      tags={
        name: "server"
      }

     }