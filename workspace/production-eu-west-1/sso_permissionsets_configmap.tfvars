sso_permissionsets_configmap = {

  "AWSCloudwatchRO" = {
    name                = "AWSCloudwatchRO"
    description         = "AWS Cloudwatch Logs RO"
    managed_policy_arns = ["arn:aws:iam::aws:policy/AWSLambdaReadOnlyAccess", "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess", "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"]
    session_duration    = "PT12H"
    inline_policy       = ""
  },

  "AWSAdministratorAccess" = {
    name                = "AWSAdministratorAccess"
    description         = "Provides full access to AWS services and resources"
    managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    session_duration    = "PT12H"
    inline_policy       = ""
  },

  "Billing" = {
    name                = "Billing"
    description         = "Provides acces to billing resources"
    managed_policy_arns = ["arn:aws:iam::aws:policy/job-function/Billing"]
    session_duration    = "PT1H"
    inline_policy       = ""
  },

  "AWSReadOnlyAccess" = {
    name                = "AWSReadOnlyAccess"
    description         = "This policy grants permissions to view resources and basic metadata across all AWS services"
    managed_policy_arns = ["arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess", "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"]
    session_duration    = "PT12H"
    inline_policy       = ""
  },

  "AWSOrganizationsFullAccess" = {
    name                = "AWSOrganizationsFullAccess"
    description         = "Provides full access to AWS Organizations"
    managed_policy_arns = ["arn:aws:iam::aws:policy/AWSOrganizationsFullAccess"]
    inline_policy       = ""
  },

  "AWSTagSecretsRW" = {
    name                = "AWSTagSecretsRW"
    description         = "Enable RW to manage secrets inside the tag path"
    managed_policy_arns = []
    session_duration    = "PT12H"
    inline_policy       = <<-EOF
        {
            "Version":"2012-10-17", 
            "Statement": [
                {
                    "Sid": "VisualEditor0", 
                    "Effect": "Allow", 
                    "Action": [
                        "secretsmanager:GetSecretValue", 
                        "secretsmanager:DescribeSecret", 
                        "secretsmanager:PutSecretValue", 
                        "secretsmanager:CreateSecret", 
                        "secretsmanager:DeleteSecret", 
                        "secretsmanager:UpdateSecret"
                    ], 
                    "Resource": [
                        "arn:aws:secretsmanager:eu-west-1:511510396203:secret:tag/*"
                    ]
                }, 
                {
                    "Sid": "VisualEditor2", 
                    "Effect": "Allow", 
                    "Action": [
                        "secretsmanager:ListSecrets"
                    ], 
                    "Resource": "*"
                }
            ]
        }
        EOF
  }

}
