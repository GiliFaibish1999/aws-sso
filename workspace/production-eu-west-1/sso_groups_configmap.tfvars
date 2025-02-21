sso_groups_configmap = {
  "AWSBillingViewers" = {
    display_name = "AWSBillingViewers"
    description  = "Access to billing in viewer mode"
    users        = ["nissim"]
  },
  "AWSLegacyViewers" = {
    display_name = "AWSLegacyViewers"
    description  = "Group of users with viewers rights to the legacy account"
    users        = ["nissim", "anatoly", "kochava-shavit"]
  },
  "AWSLegacyViewers" = {
    display_name = "AWSLegacyViewers"
    description  = "Group of users with viewers rights to the legacy account"
    users        = ["nissim", "anatoly", "kochava-shavit"]
  },
  "AWSLegacyAdmins" = {
    display_name = "AWSLegacyAdmins"
    description  = "Admin rights for legacy account"
    users        = []
  },
  "AWSTagSecretsRW"
    display_name = "AWSTagSecretsRW"
    description  = "Rights to secrets"
    users        = []
  },
  "AWSDevOps" = {
    display_name = "AWSDevOps"
    description  = "Admin rights for DevOps"
    users        = ["gili-faibish", "anatoly"]
  }
}
