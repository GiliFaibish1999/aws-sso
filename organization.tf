
resource "aws_organizations_organization" "this" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "controltower.amazonaws.com",
    "member.org.stacksets.cloudformation.amazonaws.com",
    "ram.amazonaws.com",
    "servicecatalog.amazonaws.com",
    "sso.amazonaws.com",
    "health.amazonaws.com",
  ]

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
  ]

}


resource "aws_iam_service_linked_role" "health" {
  aws_service_name = "health.amazonaws.com"
  # custom_suffix    = "Organizations_health"
}


resource "aws_organizations_delegated_administrator" "health" {
  account_id        = local.monitoring_account_id
  service_principal = "health.amazonaws.com"
}
