#!/bin/bash

# Define your profile and identity-store-id
aws_profile="123456789101_AWSAdministratorAccess"
identity_store_id="d-12345fai6g"

# Log in using AWS SSO
aws sso login --profile $aws_profile

# Export the AWS_PROFILE environment variable for subsequent AWS CLI commands
export AWS_PROFILE=$aws_profile

# Check if identity_store_id is set correctly
if [ -z "$identity_store_id" ]; then
  echo "The identity-store-id is not set. Exiting."
  exit 1
fi

# Initialize the output file
output_file="users_details.txt"
echo "User Details from IAM Identity Center" > $output_file
echo "===================================" >> $output_file

# List and describe all users, appending details to the output file
for user_id in $(aws identitystore list-users --identity-store-id $identity_store_id --query 'Users[*].UserId' --output text); do
    aws identitystore describe-user --identity-store-id $identity_store_id --user-id $user_id >> $output_file
    echo "-----------------------------------" >> $output_file
done

echo "User details have been written to $output_file"