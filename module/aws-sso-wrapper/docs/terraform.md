# Terraform AWS SSO Module

This Terraform module is designed to provision and configure AWS SSO (Single Sign-On) resources, including identity store, users, groups, and permissions.

> Empower your AWS environment with the flexibility to manage multiple hierarchies seamlessly. Our Terraform AWS SSO Module simplifies the orchestration of accounts, users, groups, and permission sets, ensuring you have the agility to handle diverse configurations effortlessly

![](./diagram.gif)

## Usage

```hcl
data "aws_ssoadmin_instances" "ssoadmin" {

}

module "sso" {
  source  = "./module/aws-sso-wrapper"

  identity_store_ids           = data.aws_ssoadmin_instances.ssoadmin.identity_store_ids
  ssoadmin_instance_arns       = data.aws_ssoadmin_instances.ssoadmin.arns
  sso_user_configmap           = var.sso_user_configmap
  sso_groups_configmap         = var.sso_groups_configmap
  sso_permissionsets_configmap = var.sso_permissionsets_configmap
  sso_account_configmap        = var.sso_account_configmap
}
```

## Variables

### 1. `identity_store_ids`

List of Identity Store IDs to search for users and groups.

```hcl
variable "identity_store_ids" {
  description = "List of Identity Store IDs to search for users and groups."
  type        = list(string)
}
```

**example:**

```hcl
identity_store_ids = ["d-sdff2704"]
```

### 2. `ssoadmin_instance_arns`

List of Identity Store Instance ARNs to search for users and groups.

```hcl
variable "ssoadmin_instance_arns" {
  description = "List of Identity Store Instance ARNs to search for users and groups."
  type        = list(string)
}

```

**example:**

```hcl
ssoadmin_instance_arns = ["arn:aws:sso:::instance/ssoins-xxxxxxxxxx"]
```

### 3. `sso_user_configmap`

Configuration for SSO Users.

```hcl
variable "sso_user_configmap" {
  description = "This sets the configuration for SSO Users"
  type = map(object({
    display_name = string
    user_name    = string
    given_name   = string
    family_name  = string
    email        = string
  }))
}

```

**example:**

```hcl
sso_user_configmap = {
  gili1 = {
    display_name = "Gili V"
    user_name    = "gili1"
    given_name   = "Gili"
    family_name  = "V"
    email        = "gili1@example.com"
  },
  gili2 = {
    display_name = "Gili V"
    user_name    = "gili2"
    given_name   = "Gili"
    family_name  = "V"
    email        = "gili2@example.com"
  }
}
```

### 4. `sso_groups_configmap`

Configuration for SSO Groups and Members.

> [!IMPORTANT]
> v1: Currently, groups and members will only be created if those users are created using the `sso_user_configmap`.\
> \
> For assistance in adding `existing users`, who were manually created on the AWS console, and mapping them to the existing `Group` and `Member`, please await the release of version 2 of this module.

```hcl
variable "sso_groups_configmap" {
  description = "This sets the configuration for SSO Users"
  type = map(object({
    display_name = string
    description  = string
    users        = list(string)
  }))
}

```

**example:**

```hcl
sso_groups_configmap = {
  "L1-devops-group" = {
    display_name = "L1-devops-group"
    description  = "This is AWS L1 Devops Group"
    users        = ["gili1", "gili2"]
  },
  "L1-Admin-group" = {
    display_name = "L1-Admin-group"
    description  = "This is AWS L1 Admin Group"
    users        = ["gili1"]
  }
}
```

### 5. `sso_permissionsets_configmap`

Configuration for AWS SSO Permission Sets with Managed Policy and Inline Policy

> [!IMPORTANT]
> list of managed policies can be attached to the permission set.

> [!CAUTION]
> Please note the following validation conditions:
>
> - The Permissionset Name key must be less than 31 characters in sso_permissionsets_configmap.
> - At least one of managed_policy_arns or inline_policy must be set in sso_permissionsets_configmap

```hcl
variable "sso_permissionsets_configmap" {
  type = map(object({
    name                = string
    description         = string
    managed_policy_arns = list(string)
    inline_policy       = string
  }))
  validation {
    condition     = length(values(var.sso_permissionsets_configmap)[*].name) <= 31
    error_message = "The Permissionset Name key must be less than 31 characters in sso_permissionsets_configmap."
  }
  validation {
    condition     = alltrue([for v in values(var.sso_permissionsets_configmap) : length(v.managed_policy_arns) > 0 || v.inline_policy != ""])
    error_message = "At least one of managed_policy_arns or inline_policy must be set in sso_permissionsets_configmap."
  }
}
```

**example:**

```hcl
sso_permissionsets_configmap = {
  "SSM-Admin-permissionset" = {
    name                = "SSM-Admin-permissionset"
    description         = "Sample Admin permissionset"
    managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"]
    inline_policy       = <<-EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Action": [
                "lambda:*",
            ],
            "Resource": "*"
            }
        ]
    }
    EOF
  },
  "SSM-testing-permissionset" = {
    name                = "SSM-testing-permissionset"
    description         = "Sample testing permissionset"
    managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess"]
    inline_policy       = <<-EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::*"
            }
        ]
    }
    EOF
  }
}
```

### 6. `sso_account_configmap`

Configuration for SSO Account.

> [!IMPORTANT]
> Supported scenarios include:
>
> - Mapping old users, groups, and permission sets.
> - Mapping new users, groups, and permission sets created using this module.
> - Migrating a combination of both old and new SSO configurations.
> - Supporting SSO creation for multiple account creations.
> - Supporting the creation of multiple users, groups, and permission sets.

```hcl
variable "sso_account_configmap" {
  description = "This sets the configuration for SSO account"
  type = map(object({
    users = map(object({
      username      = string
      permissionset = list(string)
    }))
    groups = map(object({
      groupname     = string
      permissionset = list(string)
    }))
  }))
}

```

**example:**

```hcl
sso_account_configmap = {
  "1xxxxxxxx" = {
    users = {
      giligilienv = { username = "giligilienv", permissionset = ["SSM-testing-permissionset", "SSM-Admin-permissionset"] }
    }
    groups = {
      L1devopsgroup = { groupname = "L1-devops-group", permissionset = ["SSM-testing-permissionset", "SSM-Admin-permissionset"] }
    }
  },
  "2xxxxxxxx" = {
    users = {
      giligilienv = { username = "giligilienv", permissionset = ["SSM-testing-permissionset"] }
    }
    groups = {
      L1devopsgroup = { groupname = "L1-devops-group", permissionset = ["SSM-testing-permissionset"] },
      L1AdminGroup  = { groupname = "L1-Admin-group", permissionset = ["SSM-Admin-permissionset"] }
    }
  }
}
```
<br /> <br /> 

## Resources
| Name | Type |
|------|------|
| [aws_identitystore_group.aws_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group) | resource |
| [aws_identitystore_group_membership.aws_membership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group_membership) | resource |
| [aws_identitystore_user.aws_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_user) | resource |
| [aws_ssoadmin_account_assignment.sso_account_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_account_assignment.sso_account_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_managed_policy_attachment.managed_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_managed_policy_attachment) | resource |
| [aws_ssoadmin_permission_set.permissionset](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set) | resource |
| [aws_ssoadmin_permission_set_inline_policy.inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set_inline_policy) | resource |

## Inputs 
| Name | Description        | Type      | Default | Required |
|------|--------------------|-----------|---------|:--------:|
| <a name="sso_account_configmap"></a> [sso_account_configmap](#input\sso_account_configmap) | A map that defines the configuration for each SSO account. Each account is represented by an object with fields for users and groups, each of which is a map of objects with fields for username/groupname and a list of associated permission sets. | `map(object({ users = map(object({ username = string permissionset = list(string) })) groups = map(object({ groupname = string permissionset = list(string) })) }))` | n/a | yes |
| <a name="sso_groups_configmap"></a> [sso_groups_configmap](#input\sso_groups_configmap) | A map that defines the configuration for each SSO group. Each group is represented by an object with fields for display name, description, and a list of associated users. | `map(object({ display_name = string description = string users = list(string) }))` | n/a | yes |
| <a name="sso_permissionsets_configmap"></a> [sso_permissionsets_configmap](#input\sso_permissionsets_configmap) | A map defining the configuration for each SSO permission set with fields for name, description, managed policy ARNs, and inline policy. Includes validations for the length of the Permissionset Name key and the presence of either managed_policy_arns or inline_policy. | `map(object({ name = string description = string managed_policy_arns = list(string) inline_policy = string }))` | n/a | yes |
| <a name="sso_user_configmap"></a> [sso_user_configmap](#input\sso_user_configmap) | A map that defines the configuration for each SSO user. Each user is represented by an object with fields for display name, user name, given name, family name, and email. | `map(object({ display_name = string user_name = string given_name = string family_name = string email = string }))` | n/a | yes |
| <a name="identity_store_ids"></a> [identity_store_ids](#input\identity_store_ids) | A list of Identity Store IDs for searching users and groups. | `list(string)` | `[]` | no |
| <a name="ssoadmin_instance_arns"></a> [ssoadmin_instance_arns](#input\ssoadmin_instance_arns) | A list of Identity Store Instance ARNs for searching users and groups. | `list(string)` | `[]` | no |


## Outputs
| Name | Description |
|------|-------------|
| <a name="aws_group_ids"></a> [aws_group_ids](#output\aws_group_ids) | The IDs of the AWS Identity Store Groups |
| <a name="aws_group_permissionset"></a> [aws_group_permissionset](#output\aws_group_permissionset) | The AWS SSO Permission Set for groups  |
| <a name="aws_identitystore_group"></a> [aws_identitystore_group](#output\aws_identitystore_group) | The AWS Identity Store Group details  |
| <a name="aws_identitystore_group_membership"></a> [aws_identitystore_group_membership](#output\aws_identitystore_group_membership) | The AWS Identity Store Group Membership details  |
| <a name="aws_identitystore_user"></a> [aws_identitystore_user](#output\aws_identitystore_user) |  The AWS Identity Store User details |
| <a name="aws_ssoadmin_account_assignment_group"></a> [aws_ssoadmin_account_assignment_group](#output\aws_ssoadmin_account_assignment_group) | The AWS SSO Admin Account Assignment Group details  |
| <a name="aws_ssoadmin_account_assignment_user"></a> [aws_ssoadmin_account_assignment_user](#output\aws_ssoadmin_account_assignment_user) | The AWS SSO Admin Account Assignment User details  |
| <a name="aws_ssoadmin_managed_policy_attachment"></a> [aws_ssoadmin_managed_policy_attachment](#output\aws_ssoadmin_managed_policy_attachment) | The AWS SSO Admin Managed Policy Attachment details  |
| <a name="aws_ssoadmin_permission_set"></a> [aws_ssoadmin_permission_set](#output\aws_ssoadmin_permission_set) | The AWS SSO Admin Permission Set details  |
| <a name="aws_ssoadmin_permission_set_inline_policy"></a> [aws_ssoadmin_permission_set_inline_policy](#output\aws_ssoadmin_permission_set_inline_policy) | The AWS SSO Admin Permission Set Inline Policy details  |
| <a name="aws_user_permissionset"></a> [aws_user_permissionset](#output\aws_user_permissionset) | The AWS SSO Permission Set for users  |
