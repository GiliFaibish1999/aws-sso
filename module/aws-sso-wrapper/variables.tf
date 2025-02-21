variable "identity_store_ids" {
  description = "A list of Identity Store IDs for searching users and groups."
  type        = list(string)
  default     = []

}

variable "ssoadmin_instance_arns" {
  description = "A list of Identity Store Instance ARNs for searching users and groups."
  type        = list(string)
  default     = []

}

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
  description = "A map defining the configuration for each SSO permission set with fields for name, description, managed policy ARNs, and inline policy. Includes validations for the length of the Permissionset Name key and the presence of either managed_policy_arns or inline_policy."
  type = map(object({
    name                = string
    description         = string
    managed_policy_arns = list(string)
    inline_policy       = string
    session_duration    = optional(string)
  }))
  validation {
    condition     = length(values(var.sso_permissionsets_configmap)[*].name) <= 50
    error_message = "The Permissionset Name key must be less than 50 characters in sso_permissionsets_configmap."
  }
  validation {
    condition     = alltrue([for v in values(var.sso_permissionsets_configmap) : length(v.managed_policy_arns) > 0 || v.inline_policy != ""])
    error_message = "Both managed_policy_arns and inline_policy cannot be empty in sso_permissionsets_configmap."
  }
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
