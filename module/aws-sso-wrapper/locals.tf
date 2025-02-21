
locals {
  flattened_groups = flatten([
    for k, v in var.sso_groups_configmap : [
      for u in v.users : {
        group_key = k
        user_key  = u
      }
    ]
  ])
  flattened_managed_policy_attachments = flatten([
    for k, v in var.sso_permissionsets_configmap : [
      for managed_policy_arn in v.managed_policy_arns : {
        permission_set_name = v.name
        managed_policy_arn  = managed_policy_arn
      }
    ]
  ])

  flatten_user_configurations = flatten([
    for account, config in var.sso_account_configmap : [
      for user, user_config in config.users : [
        for permission in user_config.permissionset : {
          account       = account
          username      = user_config.username
          permissionset = permission
        }
      ]
    ]
  ])

  flatten_group_configurations = flatten([
    for account, config in var.sso_account_configmap : [
      for group, group_config in config.groups : [
        for permission in group_config.permissionset : {
          account       = account
          groupname     = group_config.groupname
          permissionset = permission
        }
      ]
    ]
  ])

  unique_group_configurations = flatten([
    for account, config in var.sso_account_configmap : [
      for group, group_config in config.groups : {
        account       = account
        groupname     = group_config.groupname
        permissionset = group_config.permissionset
      }
    ]
  ])

  unique_user_configurations = flatten([
    for account, config in var.sso_account_configmap : [
      for user, user_config in config.users : {
        account       = account
        username      = user_config.username
        permissionset = user_config.permissionset
      }
    ]
  ])

}
