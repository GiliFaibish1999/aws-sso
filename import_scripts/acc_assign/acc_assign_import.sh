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
echo "STARTED... importing 760743704132.AWSBillingViewers.Billing"
terraform --environment production --region eu-west-1 import 'module.sso.aws_ssoadmin_account_assignment.sso_account_group["760743704132.AWSBillingViewers.Billing"]' $principal_id,GROUP,760743704132,AWS_ACCOUNT,$permission_set_arn,$instance_arn
echo "FINISHED! imported 760743704132.AWSBillingViewers.Billing"
echo "STARTED... importing 123456789101.AWSDevOps.AWSAdministratorAccess"
terraform --environment production --region eu-west-1 import 'module.sso.aws_ssoadmin_account_assignment.sso_account_group["123456789101.AWSDevOps.AWSAdministratorAccess"]' $principal_id,GROUP,123456789101,AWS_ACCOUNT,$permission_set_arn,$instance_arn
echo "FINISHED! imported 123456789101.AWSDevOps.AWSAdministratorAccess"
echo "STARTED... importing 123456789101.gili.faibish@gilienv.com.AWSOrganizationsFullAccess"
terraform --environment production --region eu-west-1 import 'module.sso.aws_ssoadmin_account_assignment.sso_account_user["123456789101.gili.faibish@gilienv.com.AWSOrganizationsFullAccess"]' $principal_id,USER,123456789101,AWS_ACCOUNT,$permission_set_arn,$instance_arn
echo "FINISHED! imported 123456789101.gili.faibish@gilienv.com.AWSOrganizationsFullAccess"
echo "STARTED... importing 511510396203.AWSLegacyViewers.AWSCloudwatchRO"
terraform --environment production --region eu-west-1 import 'module.sso.aws_ssoadmin_account_assignment.sso_account_group["511510396203.AWSLegacyViewers.AWSCloudwatchRO"]' $principal_id,GROUP,511510396203,AWS_ACCOUNT,$permission_set_arn,$instance_arn
echo "FINISHED! imported 511510396203.AWSLegacyViewers.AWSCloudwatchRO"
echo "STARTED... importing 511510396203.AWSLegacyViewers.AWSReadOnlyAccess"
terraform --environment production --region eu-west-1 import 'module.sso.aws_ssoadmin_account_assignment.sso_account_group["511510396203.AWSLegacyViewers.AWSReadOnlyAccess"]' $principal_id,GROUP,511510396203,AWS_ACCOUNT,$permission_set_arn,$instance_arn
echo "FINISHED! imported 511510396203.AWSLegacyViewers.AWSReadOnlyAccess"
echo "STARTED... importing 511510396203.AWSLegacyAdmins.AWSAdministratorAccess"
terraform --environment production --region eu-west-1 import 'module.sso.aws_ssoadmin_account_assignment.sso_account_group["511510396203.AWSLegacyAdmins.AWSAdministratorAccess"]' $principal_id,GROUP,511510396203,AWS_ACCOUNT,$permission_set_arn,$instance_arn
echo "FINISHED! imported 511510396203.AWSLegacyAdmins.AWSAdministratorAccess"


