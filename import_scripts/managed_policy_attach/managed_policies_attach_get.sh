#!/bin/bash

# Variables
PROFILE="123456789101_AWSAdministratorAccess"
IDENTITY_STORE_ID="d-12345fai6g"
INSTANCE_ARN="arn:aws:sso:::instance/ssoins-680480fb0594fe18"
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

# Function to process managed policies for each permission set
process_managed_policies() {
    for permission_set_arn in $permission_set_arns; do
        echo "Processing permission set ARN: $permission_set_arn..."

        # Get permission set name
        permission_set_name=$(aws sso-admin describe-permission-set --instance-arn $INSTANCE_ARN --permission-set-arn $permission_set_arn --profile $PROFILE --output json | jq -r '.PermissionSet.Name')

        if [ $? -ne 0 ]; then
            echo "Error fetching permission set details for $permission_set_arn"
            continue
        fi

        # Fetch all attached managed policies for the permission set
        managed_policy_arns=$(aws sso-admin list-managed-policies-in-permission-set --instance-arn $INSTANCE_ARN --permission-set-arn $permission_set_arn --profile $PROFILE --query "AttachedManagedPolicies[*].Arn" --output json | jq -r '.[]')

        if [ $? -ne 0 ]; then
            echo "Error fetching managed policies for permission set $permission_set_name"
            continue
        fi

        # Process each managed policy ARN
        for managed_policy_arn in $managed_policy_arns; do
            echo "  Managed policy ARN: $managed_policy_arn"

            # Write details to the file in the requested format
            echo "[$permission_set_name-$managed_policy_arn]" >> $OUTPUT_FILE
            echo "$managed_policy_arn,$permission_set_arn,$INSTANCE_ARN" >> $OUTPUT_FILE
            echo "-------------------------------------------" >> $OUTPUT_FILE
        done
    done
}

# Main script execution
login_aws_sso
fetch_permission_set_arns
process_managed_policies

echo "Managed policy attachment details have been successfully written to $OUTPUT_FILE."