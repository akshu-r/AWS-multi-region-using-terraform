# 🌍 Multi-Region High Availability on AWS with Terraform

This project demonstrates a multi-region cloud deployment using Terraform, focusing on high availability and modular design. It provisions EC2 instances in two AWS regions — `ap-south-1` and `us-west-2` — using separate modules and aliased providers.

## 🚀 Features
- Infrastructure-as-Code using Terraform
- Multi-region deployment for high availability
- Modular structure for scalability and reusability
- Uses `t2.micro` instances and custom key pairs
- Tested with Terraform v1.x and AWS provider v5.x

## 🗂 Project Structure
multi-region-ha/ 
├── main.tf 
├── variables.tf 
├── modules/ │ 
           ├── region_1/ │ │ └── main.tf 
           └── region_2/ │ └── main.tf
## Demo
![Screenshot 2025-04-15 162014](https://github.com/user-attachments/assets/8733799a-6661-4942-93f2-a05fbd912364)
