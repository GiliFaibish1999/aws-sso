output "aws_user_permissionset" {
  description = "The AWS SSO Permission Set for users"
  value       = {}
  # value       = { for k, v in data.aws_ssoadmin_permission_set.aws_user_permissionset : k => v }
}

output "aws_group_permissionset" {
  description = "The AWS SSO Permission Set for groups"
  value       = {}
  # value       = { for k, v in data.aws_ssoadmin_permission_set.aws_group_permissionset : k => v }
}

output "aws_group_ids" {
  description = "The IDs of the AWS Identity Store Groups"
  # value       = { for k, v in data.aws_identitystore_group.aws_group : k => v.group_id }
  value = {}
}


output "aws_identitystore_user" {
  description = "The AWS Identity Store User details"
  # value       = aws_identitystore_user.aws_user
  value = {}
}

output "aws_identitystore_group" {
  description = "The AWS Identity Store Group details"
  value       = aws_identitystore_group.aws_group
}

output "aws_identitystore_group_membership" {
  description = "The AWS Identity Store Group Membership details"
  value       = aws_identitystore_group_membership.aws_membership
}

output "aws_ssoadmin_permission_set" {
  description = "The AWS SSO Admin Permission Set details"
  value       = aws_ssoadmin_permission_set.permissionset
}

output "aws_ssoadmin_permission_set_inline_policy" {
  description = "The AWS SSO Admin Permission Set Inline Policy details"
  value       = aws_ssoadmin_permission_set_inline_policy.inline_policy
}

output "aws_ssoadmin_managed_policy_attachment" {
  description = "The AWS SSO Admin Managed Policy Attachment details"
  value       = aws_ssoadmin_managed_policy_attachment.managed_policy_attachment
}

output "aws_ssoadmin_account_assignment_user" {
  description = "The AWS SSO Admin Account Assignment User details"
  value       = aws_ssoadmin_account_assignment.sso_account_user
}

output "aws_ssoadmin_account_assignment_group" {
  description = "The AWS SSO Admin Account Assignment Group details"
  value       = aws_ssoadmin_account_assignment.sso_account_group
}
