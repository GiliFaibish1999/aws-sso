resource "aws_identitystore_user" "aws_user" {
  for_each          = var.sso_user_configmap
  identity_store_id = element(var.identity_store_ids, 0)

  display_name = each.value.display_name
  user_name    = each.value.user_name

  name {
    given_name  = each.value.given_name
    family_name = each.value.family_name
  }

  emails {
    primary = true
    value   = each.value.email
    type    = "work"
  }

  lifecycle {
    ignore_changes = [
      name,
      emails,
    ]
  }
}

resource "aws_identitystore_group" "aws_group" {
  for_each          = var.sso_groups_configmap
  identity_store_id = element(var.identity_store_ids, 0)
  display_name      = each.value.display_name
  description       = each.value.description
}

resource "aws_identitystore_group_membership" "aws_membership" {
  for_each          = { for identity in local.flattened_groups : "${identity.group_key}-${identity.user_key}" => identity }
  identity_store_id = element(var.identity_store_ids, 0)
  group_id          = aws_identitystore_group.aws_group[each.value.group_key].group_id
  member_id         = aws_identitystore_user.aws_user[each.value.user_key].user_id
}

resource "aws_ssoadmin_permission_set" "permissionset" {
  for_each         = var.sso_permissionsets_configmap
  name             = each.value.name
  description      = each.value.description
  instance_arn     = tolist(var.ssoadmin_instance_arns)[0]
  session_duration = each.value.session_duration != "" ? each.value.session_duration : "PT1H"
}

resource "aws_ssoadmin_permission_set_inline_policy" "inline_policy" {
  for_each           = { for k, v in var.sso_permissionsets_configmap : k => v if v.inline_policy != "" && v.inline_policy != null }
  inline_policy      = each.value.inline_policy
  instance_arn       = tolist(var.ssoadmin_instance_arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.permissionset[each.value.name].arn
}

resource "aws_ssoadmin_managed_policy_attachment" "managed_policy_attachment" {
  for_each           = { for i in local.flattened_managed_policy_attachments : "${i.permission_set_name}-${i.managed_policy_arn}" => i }
  instance_arn       = tolist(var.ssoadmin_instance_arns)[0]
  managed_policy_arn = each.value.managed_policy_arn
  permission_set_arn = aws_ssoadmin_permission_set.permissionset[each.value.permission_set_name].arn
  depends_on         = [aws_ssoadmin_account_assignment.sso_account_user, aws_ssoadmin_account_assignment.sso_account_group, ]
}

resource "aws_ssoadmin_account_assignment" "sso_account_user" {
  for_each = { for config in local.flatten_user_configurations : "${config.account}.${config.username}.${config.permissionset}" => config }

  instance_arn   = tolist(var.ssoadmin_instance_arns)[0]
  target_id      = each.value.account
  target_type    = "AWS_ACCOUNT"
  principal_id   = data.aws_identitystore_user.aws_user["${each.value.account}.${each.value.username}"].user_id
  principal_type = "USER"
  permission_set_arn = aws_ssoadmin_permission_set.permissionset[each.value.permissionset].arn
}

resource "aws_ssoadmin_account_assignment" "sso_account_group" {
  for_each = { for config in local.flatten_group_configurations : "${config.account}.${config.groupname}.${config.permissionset}" => config }

  instance_arn = tolist(var.ssoadmin_instance_arns)[0]
  target_id    = each.value.account
  target_type  = "AWS_ACCOUNT"
  principal_id   = aws_identitystore_group.aws_group[each.value.groupname].group_id
  principal_type = "GROUP"
  permission_set_arn = aws_ssoadmin_permission_set.permissionset[each.value.permissionset].arn
}
