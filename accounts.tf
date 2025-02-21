################
# AWS Accounts #
################
resource "aws_organizations_account" "account" {
  for_each  = var.aws_accounts
  name      = each.key
  email     = each.value.email
  parent_id = try(each.value.ou, null) != null ? local.data_ou_merged[each.value.ou].id : null
}


######################
# DevOps Permissions #
######################
data "aws_ssoadmin_instances" "this" {}

data "aws_ssoadmin_permission_set" "admin" {
  instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  name         = "AWSAdministratorAccess"
}

data "aws_identitystore_group" "devops" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = "AWSDevOps"
    }
  }
}

resource "aws_ssoadmin_account_assignment" "admin" {
  for_each           = aws_organizations_account.account
  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = data.aws_ssoadmin_permission_set.admin.arn

  principal_id   = data.aws_identitystore_group.devops.group_id
  principal_type = "GROUP"

  target_id   = each.value.id
  target_type = "AWS_ACCOUNT"
}
