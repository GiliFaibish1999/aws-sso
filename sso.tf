data "aws_ssoadmin_instances" "ssoadmin" {
  # No need to define any arguments here as we're importing an existing resource
}

# comment
module "sso" {
  source                       = "./module/aws-sso-wrapper"
  identity_store_ids           = data.aws_ssoadmin_instances.ssoadmin.identity_store_ids
  ssoadmin_instance_arns       = data.aws_ssoadmin_instances.ssoadmin.arns
  sso_user_configmap           = var.sso_user_configmap
  sso_groups_configmap         = var.sso_groups_configmap
  sso_permissionsets_configmap = var.sso_permissionsets_configmap
  sso_account_configmap        = var.sso_account_configmap
}
