📝 Project Documentation: Highly Available Web Application

## 🚀 My First Complete & Structured Terraform Project: Highly Available Web Application

This repository represents my first **end-to-end, fully structured** Terraform project, utilizing modules and best practices to deploy a highly available and auto-scaling web infrastructure on AWS.

This deployment is the successful culmination of effort, built directly upon the foundational knowledge and troubleshooting experience gained during the previous **`aws-high-availability-infra`** practice repository.

## 1. 🌟 Project Overview

This project uses **Terraform** to deploy a modular, highly available, and auto-scaling web application environment on **AWS**.

The infrastructure is designed to be fault-tolerant by distributing resources across two **Availability Zones (AZs)** within the `ap-south-1` (Mumbai) region.

## 2. 🏛️ Architecture & Resources

The architecture follows best practices for resilience and scalability:

  * **VPC:** A custom Virtual Private Cloud (`10.0.0.0/16`) to isolate the environment.
  * **Subnets:**
      * **2 Public Subnets:** Host the internet-facing services (**Application Load Balancer**).
      * **2 Private Subnets:** Host the application servers (**EC2 Instances**).
  * **NAT Gateways:** Two NAT Gateways (one in each Public Subnet) provide outbound internet access to the EC2 instances in the Private Subnets for updates and downloading packages.
  * **Application Load Balancer (ALB):** Distributes incoming HTTP traffic across the EC2 instances.
  * **Auto Scaling Group (ASG):** Manages the lifecycle and health of the EC2 instances, ensuring a minimum number of instances are running at all times.
  * **Launch Template:** Defines the configuration for the EC2 instances, including the Amazon Linux 2023 AMI, security group, and a `user_data` script to install and start the Apache web server (`httpd`).

## 3. ✅ Prerequisites

Before deployment, ensure you have the following installed and configured:

  * **Terraform:** CLI installed (version 1.0+).
  * **AWS CLI:** Installed and configured with credentials that have permissions to create VPC, EC2, and ELB resources.
    ```
    aws configure
    ```
  * **Project Structure:** The repository must contain the following core files and modules:
    ```
    aws-vpc-asg-infra-modular/
    │
    ├── main.tf              # Root module calls all sub-modules
    ├── variables.tf         # Root module input variables (e.g., region, VPC CIDR)
    ├── terraform.tfvars     # Variable values for deployment
    ├── provider.tf          # AWS provider configuration
    ├── outputs.tf           # Root module outputs (e.g., ALB DNS name)
    │
    └── modules/
    ├── vpc/             # Module 1: The Networking Layer (Reusable)
    │   ├── main.tf      # Creates VPC, Subnets, IGW, NAT GW, Route Tables
    │   ├── variables.tf # Defines inputs for the VPC module (e.g., CIDR blocks)
    │   ├── outputs.tf   # Exports VPC ID, Subnet IDs, NAT ID, etc.
    │
    └── compute/    # Module 2: The Application/Compute Layer
    |   ├── main.tf      # Creates SG, Launch Template, ALB, ASG
    |   ├── variables.tf # Defines inputs for the App module (e.g., instance type, desired capacity)
    |   └── outputs.tf   # Exports ALB DNS name, etc.
    ```


## 4. 🚀 Deployment Steps

Use the following commands to initialize, validate, and deploy the infrastructure.

### Step 4.1: Initialize Terraform

Initialize the working directory to download providers and modules.

```
terraform init
```

### Step 4.2: Review the Plan

Generate and review the execution plan. This command confirms the **24 resources** to be created.

```
terraform plan
```

### Step 4.3: Apply the Configuration

Deploy the infrastructure to your AWS account. You will need to type `yes` to confirm.

```
terraform apply
```

### Step 4.4: Retrieve the Application URL

After a successful deployment, retrieve the DNS name of the newly created Application Load Balancer.

```
terraform output alb_dns_name
```

## 5. 🧪 Verification & Troubleshooting

Once the deployment is complete, verify functionality:

1.  **Application Access:** Paste the `alb_dns_name` into a web browser. You should see the custom "Hello from..." message served by the EC2 instances.
2.  **Health Check:** Go to the AWS console $\rightarrow$ EC2 $\rightarrow$ Target Groups $\rightarrow$ `TerraformProject-TG`. Confirm the instances show a **Healthy** status.


**⚠️ Bad Gateway (502) or Unhealthy Targets:**

If you encounter a **502 Bad Gateway** error, the issue is most likely with the web server startup. Check the EC2 system logs to verify the `launchScript.sh` successfully ran and ensure the **EC2 Security Group** allows inbound traffic on Port 80 from the **ALB Security Group ID**.

## 6. 🗑️ Clean-up and Decommissioning

**ATTENTION: Failure to perform this step will result in ongoing AWS charges.**

When you are finished testing, use the `destroy` command to safely remove all provisioned resources.

1.  **Run the Destroy Command:**
    ```
    terraform destroy
    ```
2.  **Confirm Deletion:** When prompted, type **`yes`** to approve the destruction of all 24 resources.

## 🛑 Post-Deployment Troubleshooting & Lessons Learned

This section documents critical issues encountered during the initial deployment and the fixes applied.

## 1. ⚠️ Deployment Failure: Invalid Subnet IDs
```
| Detail | Cause | Impact | The Fix |
| :--- | :--- | :--- | :--- |
| **Error Type** | AWS API Error (`InvalidSubnet`) | Terraform failed to create the ALB and ASG. |
| **Cause** | The `vpc` module was configured to output the **Subnet CIDR blocks** (`10.0.1.0/24`) instead of the required unique **Subnet IDs** (`subnet-xxxxxxxx`). | AWS APIs strictly require resource IDs for linking components. | Updated **`modules/vpc/outputs.tf`** to export the resource ID attribute: `value = aws_subnet.Public_Subnet[*].id` |
```

## 2. ❌ Application Failure: Bad Gateway (502) & Unhealthy Targets

These issues occurred after the networking resources were created but before the application was fully operational.
```
| Detail | Cause | Impact | The Fix |
| :--- | :--- | :--- | :--- |
| **Problem 1: Health Check Failure** | The Target Group reported instances as **Unhealthy** (due to connection refusal). | The Load Balancer did not forward traffic, resulting in a **502 Bad Gateway** error. | Modified the **EC2 Security Group (EC2-SG)** to allow inbound Port 80 traffic only from the **ALB's Security Group ID** (`security_groups = [aws_security_group.ALB_SG.id]`). |
| **Problem 2: Web Server Crash** | The `launchScript.sh` contained critical typos and syntax errors (e.g., `Systemctl` instead of `systemctl`, and an unclosed quote). | The Apache web server (`httpd`) failed to start during instance boot, even if the security group was correct. | Corrected the **`launchScript.sh`** to use **lowercase Linux commands** and validated all script syntax/quotes. The Launch Template was updated with the new script version. |
| **Problem 3: Slow Recovery** | The Auto Scaling Group (`ASG`) was using `health_check_type = "EC2"`. | The ASG relied solely on basic instance checks, leading to delays and potential misclassification of instances that had application issues. | Changed the ASG setting to **`health_check_type = "ELB"`**. This forces the ASG to rely on the ALB's application-level health checks, ensuring only truly operational instances are retained. |
```

## 💡 Key Takeaway

Always verify **resource dependency requirements** (IDs vs. CIDR) and meticulously test **User Data scripts** before deployment, as bootstrap failures are often the root cause of application-level issues in a functioning network stack.