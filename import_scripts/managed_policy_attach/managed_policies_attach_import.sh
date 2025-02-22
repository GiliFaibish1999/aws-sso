#!/bin/bash

# Variables
PROFILE="123456789101_AWSAdministratorAccess"


# Ensure AWS CLI is configured to use the specified profile
export AWS_PROFILE=$PROFILE

# Login to AWS SSO
aws sso login --profile $PROFILE

# Check if login was successful
if [[ $? -ne 0 ]]; then
    echo "Failed to login to AWS SSO with profile $PROFILE."
    exit 1
fi

# Example for import
echo "STARTED... importing AWSAdministratorAccess-arn:aws:iam::aws:policy/AdministratorAccess"
terraform --environment production --region eu-west-1 import 'module.sso.aws_ssoadmin_managed_policy_attachment.managed_policy_attachment["AWSAdministratorAccess-arn:aws:iam::aws:policy/AdministratorAccess"]' $managed_policy_arn,$permission_set_arn,$instance_arn
echo "FINISHED! imported AWSAdministratorAccess-arn:aws:iam::aws:policy/AdministratorAccess"
echo "STARTED... importing AWSCloudwatchRO-arn:aws:iam::aws:policy/AWSLambdaReadOnlyAccess"
terraform --environment production --region eu-west-1 import 'module.sso.aws_ssoadmin_managed_policy_attachment.managed_policy_attachment["AWSCloudwatchRO-arn:aws:iam::aws:policy/AWSLambdaReadOnlyAccess"]' $managed_policy_arn,$permission_set_arn,$instance_arn
echo "FINISHED! imported AWSCloudwatchRO-arn:aws:iam::aws:policy/AWSLambdaReadOnlyAccess"
echo "STARTED... importing AWSCloudwatchRO-arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
terraform --environment production --region eu-west-1 import 'module.sso.aws_ssoadmin_managed_policy_attachment.managed_policy_attachment["AWSCloudwatchRO-arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"]' $managed_policy_arn,$permission_set_arn,$instance_arn
echo "FINISHED! imported AWSCloudwatchRO-arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
echo "STARTED... importing Billing-arn:aws:iam::aws:policy/job-function/Billing"
terraform --environment production --region eu-west-1 import 'module.sso.aws_ssoadmin_managed_policy_attachment.managed_policy_attachment["Billing-arn:aws:iam::aws:policy/job-function/Billing"]' $managed_policy_arn,$permission_set_arn,$instance_arn
echo "FINISHED! imported Billing-arn:aws:iam::aws:policy/job-function/Billing"
