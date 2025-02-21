################
# AWS Accounts #
################
aws_accounts = {
  monitoring = {
    name  = "monitoring"
    email = "devops+monitoring@gilienv.com"
    ou    = "monitoring"
  }
  integration-sandbox = {
    name  = "integration-sandbox"
    email = "devops+integrationsandbox@gilienv.com"
    ou    = "sandbox"
  }
  staging-network = {
    name  = "staging-network"
    email = "devops+stagingnetwork@gilienv.com"
    ou    = "core-infrastructure/staging"
  }
  continuous-delivery = {
    name  = "continuous-delivery"
    email = "devops+continuousdelivery@gilienv.com"
    ou    = "platform-engineering"
  }
  staging-front = {
    name  = "staging-front"
    email = "devops+stagingfront@gilienv.com"
    ou    = "workloads/staging"
  }
  production-front = {
    name  = "production-front"
    email = "devops+productionfront@gilienv.com"
    ou    = "workloads/production"
  }
  production-integrations = {
    name  = "production-integrations"
    email = "devops+productionintegrations@gilienv.com"
    ou    = "workloads/production"
  }
}
