#######
# OUs #
#######
organizational_units = {
  # New Organizational Units
  security = {
    create = true
  }
  core-infrastructure = {
    create = true
    children = {
      staging = { create = true }
    }
  }
  secrets = {
    create = true
  }
  monitoring = {
    create = true
  }
  platform-engineering = {
    create = true
  }
  sandbox = {
    create = true
  }
  workloads = {
    create = false
  }
  # Legacy Organizational Units
  Epoq = {
    create   = false
    children = {}
  }
}
