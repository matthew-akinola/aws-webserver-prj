
# Web Application AWS Environment Setup

This repository contains Terraform scripts to set up an AWS environment for launching a new web application. The infrastructure includes an auto-scaling EC2 setup behind a load balancer and an RDS instance, ensuring secure communication between them.

# Architecture

The architecture consists of the following components:
1. Virtual Private Cloud (VPC): A logically isolated section of the AWS cloud where resources are provisioned.
2. Subnet: A subdivision of the VPC that allows you to group resources based on security and operational requirements.
3. Security Group: A virtual firewall that controls inbound and outbound traffic for EC2 instances and RDS instances.
4. Load Balancer: Distributes incoming traffic across multiple EC2 instances to ensure high availability and scalability.
5. Auto Scaling Group: Automatically adjusts the number of EC2 instances based on the load to maintain performance and availability.
6. RDS Instance: A managed relational database service for storing application data.
7. Cloudwatch: Collects monitoring and operational data in the form of logs, metrics, and events.

# Security Checks
- Backend configuration was stored in S3 bucket
- Secret credentials were managed using Secret Manager
- Traffic is managed via two load balancers: an external one directing to an Nginx reverse proxy, and an internal one interfacing with the web servers.
- Nginx was configured as a reverse proxy to direct incoming traffic from external load balancer to internal load balancer

# Prerequisites

Before executing the Terraform scripts, ensure that you have the following prerequisites:
1. AWS Account: Create an AWS account if you don't have one already.
AWS CLI: Install the AWS Command Line Interface by following the instructions in the AWS CLI User Guide.
2. Terraform: Install Terraform by following the instructions in the Terraform Installation Guide.

# Execution Instructions

To set up the AWS environment, follow these steps:
1. Clone the Repository: Clone this repository to your local machine using the following command:
- `git clone https://github.com/matthew-akinola/aws-webserver-prj.git`

2. Configure AWS Credentials: Configure your AWS credentials by running the following command and providing your AWS access key ID and secret access key:
- `aws configure`

3. Initialize Terraform: Change into the cloned repository directory and initialize Terraform by running the following command:
- `cd aws-webserver-prj`
- `terraform init`

4. Review and Customize Variables: Open the variables.tf file and review the variables. Customize them according to your requirements. For example, you can modify the region, instance type, database engine, etc.
5. Validate the Configuration: Run the following command to validate the Terraform configuration:
- `terraform validate`
6. Plan the Infrastructure: Generate an execution plan to review the changes that Terraform will make to your infrastructure:
- `terraform plan` 
7. Apply the Infrastructure: Apply the Terraform execution plan to create the AWS environment:
- `terraform apply`
- Enter `yes` when prompted to confirm the execution.
8. Wait for Provisioning: Terraform will provision the infrastructure components. This process may take a few minutes. Once completed, you will see the output with the details of the created resources.
9. Access the Web Application: Once the infrastructure is provisioned, you can access the web application by using the load balancer's DNS name or IP address. 

# NOTE
- A TLS certificate was configured in the `modules/ALB`, reconfigure it for your domain. This enables an HTTPS request. 
- Comment out the backend configuration in the `backend.tf` and apply. After successful `terraform apply`, uncomment the configuration and apply again. This will ensure S3 bucket is created first