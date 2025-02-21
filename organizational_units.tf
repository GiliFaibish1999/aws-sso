#######
# OUs #
#######
data "aws_organizations_organizational_units" "parents" {
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

data "aws_organizations_organizational_units" "children" {
  for_each  = { for k, v in local.data_ou_parents : k => v if try(v.create, false) == false }
  parent_id = local.data_ou_parents[each.key].id
}

resource "aws_organizations_organizational_unit" "parents" {
  for_each  = { for k, v in var.organizational_units : k => v if try(v.create, false) != false }
  name      = each.key
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

resource "aws_organizations_organizational_unit" "children" {
  for_each  = local.ou_children
  name      = each.value.name
  parent_id = try(var.organizational_units[each.value.parent].create, false) == false ? local.data_ou_parents[each.value.parent].id : aws_organizations_organizational_unit.parents[each.value.parent].id
}
