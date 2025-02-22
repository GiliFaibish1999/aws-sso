#!/bin/bash

# Variables
PROFILE="123456789101_AWSAdministratorAccess"
IDENTITY_STORE_ID="d-12345fai6g"
INSTANCE_ARN="arn:aws:sso:::instance/ssoins-678910fb11121fe31"
OUTPUT_FILE="acc_assign.txt"

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

# Fetch account IDs from the organization
fetch_account_ids() {
    echo "Fetching account IDs..."
    ACCOUNT_IDS=$(aws organizations list-accounts --profile $PROFILE --output json | jq -r '.Accounts[].Id')
    
    if [ $? -ne 0 ]; then
        echo "Error fetching account IDs. Please ensure you have permissions to list accounts."
        exit 1
    fi
}

# Write the headers to the output file
write_headers() {
    echo "principal_id,principal_type,target_id,target_type,permission_set_arn,instance_arn" >> $OUTPUT_FILE
    echo "Account ID, Assigned Group/User Name, Assigned Group/User Permission Set Name" >> $OUTPUT_FILE
}

# Process each account assignment and output required details
process_assignments() {
    for account_id in $ACCOUNT_IDS; do
        echo "Processing account ID: $account_id..."

        # Fetch permission set ARNs for the account
        permission_set_arns=$(aws sso-admin list-permission-sets --instance-arn $INSTANCE_ARN --profile $PROFILE --output json | jq -r '.PermissionSets[]')

        if [ $? -ne 0 ]; then
            echo "Error fetching permission sets for account ID: $account_id"
            continue
        fi

        for permission_set_arn in $permission_set_arns; do
            echo "Processing permission set ARN: $permission_set_arn..."

            # Fetch account assignments for this account, instance, and permission set
            assignments=$(aws sso-admin list-account-assignments --instance-arn $INSTANCE_ARN --account-id $account_id --permission-set-arn $permission_set_arn --profile $PROFILE --output json)

            if [ $? -ne 0 ]; then
                echo "Error fetching account assignments for account ID: $account_id and permission set ARN: $permission_set_arn"
                continue
            fi

            # Process each assignment and extract necessary details
            echo "$assignments" | jq -c '.AccountAssignments[]' | while read assignment; do
                principal_id=$(echo "$assignment" | jq -r '.PrincipalId')
                principal_type=$(echo "$assignment" | jq -r '.PrincipalType')
                target_id=$(echo "$account_id")
                target_type=$(echo "AWS_ACCOUNT")
                permission_set_arn=$(echo "$assignment" | jq -r '.PermissionSetArn')

                # Fetch user or group details based on PrincipalType
                if [[ "$principal_type" == "USER" ]]; then
                    user_details=$(aws identitystore describe-user --identity-store-id $IDENTITY_STORE_ID --user-id $principal_id --profile $PROFILE --output json)
                    user_name=$(echo "$user_details" | jq -r '.UserName')
                    assigned_name="$user_name"
                else
                    group_details=$(aws identitystore describe-group --identity-store-id $IDENTITY_STORE_ID --group-id $principal_id --profile $PROFILE --output json)
                    group_name=$(echo "$group_details" | jq -r '.DisplayName')
                    assigned_name="$group_name"
                fi

                # Fetch permission set name
                permission_set_name=$(aws sso-admin describe-permission-set --instance-arn $INSTANCE_ARN --permission-set-arn $permission_set_arn --profile $PROFILE --output json | jq -r '.PermissionSet.Name')

                # Write the second section to the output file
                if [[ "$principal_type" == "USER" ]]; then
                echo "module.sso.aws_ssoadmin_account_assignment.sso_account_user[$account_id.$assigned_name.$permission_set_name]" >> $OUTPUT_FILE
                else 
                echo "module.sso.aws_ssoadmin_account_assignment.sso_account_group[$account_id.$assigned_name.$permission_set_name]" >> $OUTPUT_FILE
                fi
                # Write the basic assignment details to the file
                echo "$principal_id,$principal_type,$target_id,$target_type,$permission_set_arn,$INSTANCE_ARN" >> $OUTPUT_FILE
                echo "-------------------------------------------" >> $OUTPUT_FILE
            done
        done
    done
}

# Main script execution
login_aws_sso
fetch_account_ids
write_headers
process_assignments

echo "SSO account assignments have been successfully written to $OUTPUT_FILE."