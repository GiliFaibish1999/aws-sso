#!/bin/bash

# Variables
PROFILE="123456789101_AWSAdministratorAccess"
IDENTITY_STORE_ID="d-12345fai6g"
INSTANCE_ARN="arn:aws:sso:::instance/ssoins-678910fb11121fe31"
OUTPUT_FILE="managed_policy_attachments.txt"

# Clear the output file if it exists
> $OUTPUT_FILE

# Function to check for AWS credentials and login
login_aws_sso() {
    echo "Logging into AWS SSO..."
    aws sso login --profile $PROFILE
    
    if [ $? -ne 0 ]; then
        echo "Unable to locate credentials. Please ensure you are logged in to AWS SSO."
        exit 1
    fi
}

# Function to fetch permission set ARNs
fetch_permission_set_arns() {
    echo "Fetching permission sets..."
    permission_set_arns=$(aws sso-admin list-permission-sets --instance-arn $INSTANCE_ARN --profile $PROFILE --output json | jq -r '.PermissionSets[]')
    
    if [ $? -ne 0 ]; then
        echo "Error fetching permission sets. Please check your permissions."
        exit 1
    fi
}

# Function to process permission sets
process_permission_sets() {
    for permission_set_arn in $permission_set_arns; do

        # Get permission set name
        permission_set_name=$(aws sso-admin describe-permission-set --instance-arn $INSTANCE_ARN --permission-set-arn $permission_set_arn --profile $PROFILE --output json | jq -r '.PermissionSet.Name')

        # Write to output
        echo "Name: $permission_set_name" >> $OUTPUT_FILE
        echo "PS-ARN: $permission_set_arn" >> $OUTPUT_FILE
        echo "Instance-ARN: $INSTANCE_ARN" >> $OUTPUT_FILE
    done
}

# Main script execution
login_aws_sso
fetch_permission_set_arns
process_permission_sets

echo "Permission Sets details have been successfully written to $OUTPUT_FILE."