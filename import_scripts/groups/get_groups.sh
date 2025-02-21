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
output_file="groups_details.txt"
echo "Group Details from IAM Identity Center" > $output_file
echo "====================================" >> $output_file

# List and describe all groups, appending details to the output file
for group_id in $(aws identitystore list-groups --identity-store-id $identity_store_id --query 'Groups[*].GroupId' --output text); do
    aws identitystore describe-group --identity-store-id $identity_store_id --group-id $group_id >> $output_file
    echo "-----------------------------------" >> $output_file
done

echo "Group details have been written to $output_file"