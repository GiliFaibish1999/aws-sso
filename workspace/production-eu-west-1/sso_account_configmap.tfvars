sso_account_configmap = {
  "760743704132" = {
      users = {}
      groups = {
          AWSBillingViewers = { groupname = "AWSBillingViewers", permissionset = ["Billing"] }
      }
  },
  "123456789101" = {
    users = {
      gili-faibish = { username = "gili.faibish@gilienv.com", permissionset = ["AWSOrganizationsFullAccess"] }
    }
    groups = {
      AWSDevOps = { groupname = "AWSDevOps", permissionset = ["AWSAdministratorAccess"] }
    }
  },
  "511510396203" = {
    users = {}
    groups = {
      AWSLegacyViewers = { groupname = "AWSLegacyViewers", permissionset = ["AWSCloudwatchRO", "AWSReadOnlyAccess"] },
      AWSLegacyAdmins = { groupname = "AWSLegacyAdmins", permissionset = ["AWSAdministratorAccess"] },
    }
  }
}
