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
echo "STARTED... importing Billing"
terraform --environment production --region eu-west-1 import 'module.sso.aws_ssoadmin_permission_set.permissionset["Billing"]' $permission_set_arn,$instance_arn
echo "FINISHED! imported Billing"
echo "STARTED... importing AWSReadOnlyAccess"
terraform --environment production --region eu-west-1 import 'module.sso.aws_ssoadmin_permission_set.permissionset["AWSReadOnlyAccess"]' $permission_set_arn,$instance_arn
echo "FINISHED! imported AWSReadOnlyAccess"