############
## Global ##
############

variable "region" {
  description = "The default AWS region to use"
  type        = string
}

variable "environment" {
  description = "The default environment to use"
  type        = string
}

################
# AWS Accounts #
################
variable "aws_accounts" {
  description = "A map of aws child accounts configurations"
  type = map(object({
    email = string
    ou    = optional(string)
  }))
}

#######
# OUs #
#######
variable "organizational_units" {
  description = "A map of aws organizational units configurations"
  type = map(object({
    create = optional(bool)
    children = optional(map(object({
      create = optional(bool)
    })))
  }))
}

##################
# SSO management #
##################
variable "sso_user_configmap" {
  description = "A map that defines the configuration for each SSO user. Each user is represented by an object with fields for display name, user name, given name, family name, and email."
  type = map(object({
    display_name = string
    user_name    = string
    given_name   = string
    family_name  = string
    email        = string
  }))
}

variable "sso_groups_configmap" {
  description = "A map that defines the configuration for each SSO group. Each group is represented by an object with fields for display name, description, and a list of associated users."
  type = map(object({
    display_name = string
    description  = string
    users        = list(string)
  }))
}

variable "sso_permissionsets_configmap" {
  description = "A map that defines the configuration for each SSO permission set. Each permission set is represented by an object with fields for name, description, a list of managed policy ARNs, and an inline policy."
  type = map(object({
    name                = string
    description         = string
    managed_policy_arns = list(string)
    inline_policy       = string
    session_duration    = optional(string)
  }))
}

variable "sso_account_configmap" {
  description = "A map that defines the configuration for each SSO account. Each account is represented by an object with fields for users and groups, each of which is a map of objects with fields for username/groupname and a list of associated permission sets."
  type = map(object({
    users = map(object({
      username      = string
      permissionset = list(string)
    }))
    groups = map(object({
      groupname     = string
      permissionset = list(string)
    }))
  }))
}
