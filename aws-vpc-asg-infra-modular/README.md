FOLDER STRUCTURE
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
    └── app-web-tier/    # Module 2: The Application/Compute Layer
        ├── main.tf      # Creates SG, Launch Template, ALB, ASG
        ├── variables.tf # Defines inputs for the App module (e.g., instance type, desired capacity)
        └── outputs.tf   # Exports ALB DNS name, etc.
```