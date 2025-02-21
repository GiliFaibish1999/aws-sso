#!/bin/bash

# AWS configuration
PROFILE="123456789101_AWSAdministratorAccess"
IDENTITY_STORE_ID="d-12345fai6g"
OUTPUT_FILE="memberships_details.txt"

# Clear the output file if it exists
> $OUTPUT_FILE

# Log into AWS SSO with the given profile
echo "Logging into AWS SSO..."
aws sso login --profile $PROFILE
if [ $? -ne 0 ]; then
    echo "Failed to login. Exiting."
    exit 1
fi

echo "Retrieving group memberships from AWS IAM Identity Center..."

# Get the list of all groups in the Identity Store
groups=$(aws identitystore list-groups --identity-store-id $IDENTITY_STORE_ID --profile $PROFILE --output json)

# Parse the group IDs and group names
group_ids=$(echo $groups | jq -r '.Groups[].GroupId')

# Loop through each group
for group_id in $group_ids; do
    group_name=$(echo $groups | jq -r ".Groups[] | select(.GroupId==\"$group_id\") | .DisplayName")

    echo "Processing group: $group_name (GroupId: $group_id)"

    # Get all group memberships for the current group
    memberships=$(aws identitystore list-group-memberships --identity-store-id $IDENTITY_STORE_ID --group-id $group_id --profile $PROFILE --output json)

    # Parse the membership details
    membership_ids=$(echo $memberships | jq -r '.GroupMemberships[].MembershipId')

    for membership_id in $membership_ids; do
        # Get the member user ID
        user_id=$(echo $memberships | jq -r ".GroupMemberships[] | select(.MembershipId==\"$membership_id\") | .MemberId.UserId")

        # Check if user_id is non-empty
        if [[ -z "$user_id" ]]; then
            echo "User ID not found for Membership ID: $membership_id. Skipping."
            continue
        fi

        # Fetch the user's display name using their user ID
        user_details=$(aws identitystore describe-user --identity-store-id $IDENTITY_STORE_ID --user-id $user_id --profile $PROFILE --output json)

        # Extract DisplayName from user details
        user_display_name=$(echo $user_details | jq -r '.DisplayName')

        # Check if DisplayName was retrieved
        if [[ -z "$user_display_name" || "$user_display_name" == "null" ]]; then
            user_display_name="N/A"
        fi

        # Write the details to the output file
        echo "Group Name: $group_name" >> $OUTPUT_FILE
        echo "User Display Name: $user_display_name" >> $OUTPUT_FILE
        echo "Membership ID: $membership_id" >> $OUTPUT_FILE
        echo "User ID: $user_id" >> $OUTPUT_FILE
        echo "-----------------------------" >> $OUTPUT_FILE
    done
done

echo "All group membership details have been written to $OUTPUT_FILE."