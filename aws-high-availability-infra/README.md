Project Structure:-

terraform-aws-high-availability-infra/
│
├── provider.tf
├── variables.tf
├── outputs.tf
├── main.tf
├── terraform.tfvars
│
├── vpc/
│   ├── vpc.tf
│   ├── subnets.tf
│   ├── route_tables.tf
│   ├── nat.tf
│   ├── security_groups.tf
│
├── compute/
│   ├── bastion.tf
│   ├── launch_template.tf
│   ├── autoscaling.tf
│
├── alb/
│   ├── alb.tf
│   ├── target_group.tf
│   ├── listener.tf
│
└── variables/
    ├── vpc_variables.tf
    ├── compute_variables.tf
    ├── alb_variables.tf
