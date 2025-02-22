# 🌍 AWS-SSO Master Organization Management Project

This project provides a **comprehensive AWS SSO Management Module** built with Terraform to manage AWS Organizations efficiently. The solution streamlines identity and access management across multiple AWS accounts, ensuring security, scalability, and governance best practices.
The repository includes a module and usage example for AWS-SSO.  

## 📌 Overview

This project includes:
- A **Terraform module** for AWS SSO resource management.
- **Import scripts** to migrate existing resources seamlessly.
- A **usage example** demonstrating real-world implementation.

---

## 🧑‍🧒‍🧒 AWS-master-account
This Terraform stack has the role to manage the AWS master account `gili-master` :
* users management
* groups management
* accounts management
* permission sets management
* organization units management

### 🚀 Usage

```shell           
export AWS_PROFILE=123456789101_AWSAdministratorAccess
terraform --environment production --region eu-west-1 apply
```

### ⚛️ TerraForm Requirements

The stack require to use TerraForm >= 1.2.0

---

## 🏗️ AWS SSO Module

The **AWS SSO Wrapper Module** automates the provisioning and management of user access and permissions across multiple AWS accounts in an AWS Organization, it handles:
✔️ Accounts
✔️ Users 
✔️ Groups  
✔️ Permission Sets  

This module serves as the foundation for both legacy and future AWS SSO resource management.

📜 **[Terraform Module Documentation](./module/aws-sso-wrapper/docs/terraform.md)**

### 📌 Architecture Diagram
![AWS SSO Module Diagram](./module/aws-sso-wrapper/docs/diagram.gif)

---

## 🔄 Import Scripts
For importing existing resources into the module.

To onboard legacy users, groups, and configurations into the module, this project includes custom **import scripts**.

### 📜 **[Imports Documentation](./import_scripts/docs/imports.md)**  

---





