output "accounts" {
  value = aws_organizations_account.account
}

output "monitoring_account_id" {
  value = local.monitoring_account_id
}

output "aws_ssoadmin_instances_arns" {
  value = data.aws_ssoadmin_instances.ssoadmin.arns
}

output "aws_ssoadmin_instances_identitystoreid" {
  value = data.aws_ssoadmin_instances.ssoadmin.identity_store_ids
}

