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

# Example for users import
echo "STARTED... importing gili-faibish"
terraform --environment production --region eu-west-1 import 'module.sso.aws_identitystore_user.aws_user["gili-faibish"]' d-12345fai6g/$user_id
echo "FINISHED! imported gili-faibish"
echo "STARTED... importing kochava-shavit"
terraform --environment production --region eu-west-1 import 'module.sso.aws_identitystore_user.aws_user["kochava-shavit"]' d-12345fai6g/$user_id
echo "FINISHED! imported kochava-shavit"
echo "STARTED... importing nissim"
terraform --environment production --region eu-west-1 import 'module.sso.aws_identitystore_user.aws_user["nissim"]' d-12345fai6g/$user_id
echo "FINISHED! imported nissim"
echo "STARTED... importing anatoly"
terraform --environment production --region eu-west-1 import 'module.sso.aws_identitystore_user.aws_user["anatoly"]' d-12345fai6g/$user_id
echo "FINISHED! imported anatoly"