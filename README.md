# terraform

Overview:
This project involves using Terraform to provision the necessary AWS infrastructure for hosting a web application. The infrastructure includes a Virtual Private Cloud (VPC), subnets, a route table, an internet gateway, a security group, an EC2 instance, and a key pair for SSH access.

Infrastructure Components:

AWS Provider Configuration:

Region: ap-south-1
Access Key and Secret Key: These are provided as input variables (var.access and var.secret_key).
AWS Virtual Private Cloud (VPC):

CIDR Block: Defined by the input variable var.vpc_cidr.
Tags: A tag with the name "${var.env_prefix}-vpc" is added.
AWS Subnet:

VPC ID: References the AWS VPC created earlier.
CIDR Block: Defined by the input variable var.subnet_cidr.
Availability Zone: Defined by the input variable var.avail_zone.
Tags: A tag with the name "${var.env_prefix}-subnet-1" is added.
AWS Route Table:

VPC ID: References the AWS VPC created earlier.
Default Route: A default route with CIDR block "0.0.0.0/0" is associated with an internet gateway.
Tags: A tag with the name "${var.env_prefix}-table" is added.
AWS Internet Gateway:

VPC ID: References the AWS VPC created earlier.
Tags: A tag with the name "${var.env_prefix}-gateway" is added.
AWS Route Table Association:

Subnet ID: References the AWS Subnet created earlier.
Route Table ID: References the AWS Route Table created earlier.
AWS Security Group:

Name: "sg"
VPC ID: References the AWS VPC created earlier.
Ingress Rules:
Allows incoming traffic on port 22 (SSH) from anywhere.
Allows incoming traffic on port 8080 from anywhere.
Egress Rules:
Allows all outbound traffic to anywhere.
Tags: A tag with the name "${var.env_prefix}-sg" is added.
AWS Amazon Machine Image (AMI):

Retrieves the latest Amazon Linux 2 AMI.
Filters for a specific name and virtualization type.
AWS Key Pair:

Creates an AWS key pair named "server-key."
Associates the public key from the local file "/Users/tusharsharma/.ssh/id_rsa.pub."
AWS EC2 Instance:

Uses the retrieved AMI ID for the Amazon Linux 2 image.
Instance Type: t2.micro.
Subnet ID: References the AWS Subnet created earlier.
Security Group IDs: References the AWS Security Group created earlier.
Availability Zone: Defined by the input variable var.avail_zone.
Associates a public IP address.
Specifies the key pair for SSH access.
Runs a user data script from the file "entry-script.sh."
Tags the instance with the name "server."
Usage:
To use this Terraform configuration, you need to provide values for the input variables (access, secret_key, vpc_cidr, subnet_cidr, avail_zone, and env_prefix) and ensure that the required SSH key pair file ("id_rsa.pub") exists at the specified path.

This configuration will create a secure VPC environment in the ap-south-1 region, set up a web server instance with the specified security group rules, and associate it with a public IP address. The project is ready for further customization and deployment of web applications.



<img width="1236" alt="Screenshot 2023-10-05 at 4 21 59 PM" src="https://github.com/Tushar240503/terraform/assets/98592305/e740dd54-923c-445d-9904-ac2da45eede7">
<img width="958" alt="Screenshot 2023-10-05 at 4 22 27 PM" src="https://github.com/Tushar240503/terraform/assets/98592305/a5046939-83d4-48ec-ac00-1d6e317574db">

