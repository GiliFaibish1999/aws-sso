data "aws_organizations_organization" "this" {}

locals {
  terraform_stack = "aws-master-account"

  #######
  # OUs #
  #######
  ou_children = merge(flatten([
    for l1, l2 in var.organizational_units : {
      for k, v in l2.children : trim(format("%s/%s", l1, k), "/") => {
        path   = trim(format("%s/%s", l1, k), "/")
        name   = k
        create = v.create
        parent = l1
      } if try(v.create, false) != false
    } if l2.children != null
  ])...)

  data_ou_parents = {
    for child in data.aws_organizations_organizational_units.parents.children : child.name => {
      id = child.id
    }
  }

  data_ou_children = merge(flatten([
    for l1, l2 in data.aws_organizations_organizational_units.children : {
      for k, v in l2.children : trim(format("%s/%s", l1, v.name), "/") => {
        id = v.id
      }
    }
  ])...)

  data_ou_merged = merge(local.data_ou_parents, local.data_ou_children)

  ##################
  # Monitoring ID #
  ##################
  monitoring_account_id = lookup({ for acc in aws_organizations_account.account : acc.name => acc.id if acc.name == "monitoring" }, "monitoring", null)

}
