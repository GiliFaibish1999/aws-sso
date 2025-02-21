data "aws_identitystore_user" "aws_user" {
  for_each = { for config in local.unique_user_configurations : "${config.account}.${config.username}" => config }

  identity_store_id = element(var.identity_store_ids, 0)
  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = each.value.username
    }
  }
}
