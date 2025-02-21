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

# Example for groups import
echo "STARTED... importing AWSDevOps"
abform --environment production --region eu-west-1 import 'module.sso.aws_identitystore_group.aws_group["AWSDevOps"]' d-12345fai6g/$group_id
echo "FINISHED! imported AWSDevOps"
echo "STARTED... importing AWSBillingViewers"
abform --environment production --region eu-west-1 import 'module.sso.aws_identitystore_group.aws_group["AWSBillingViewers"]' d-12345fai6g/$group_id
echo "FINISHED! imported AWSBillingViewers"
echo "STARTED... importing AWSLegacyViewers"
abform --environment production --region eu-west-1 import 'module.sso.aws_identitystore_group.aws_group["AWSLegacyViewers"]' d-12345fai6g/$group_id
echo "FINISHED! imported AWSLegacyViewers"
echo "STARTED... importing AWSLegacyAdmins"
abform --environment production --region eu-west-1 import 'module.sso.aws_identitystore_group.aws_group["AWSLegacyAdmins"]' d-12345fai6g/$group_id
echo "FINISHED! imported AWSLegacyAdmins"