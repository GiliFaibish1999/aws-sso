
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

# Example for membership import
echo "STARTED... importing AWSDevOps-gili-faibish"
terraform --environment production --region eu-west-1 import 'module.sso.aws_identitystore_group_membership.aws_membership["AWSDevOps-gili-faibish"]' d-12345fai6g/$membership_id
echo "FINISHED! imported AWSDevOps-gili-faibish"
echo "STARTED... importing AWSDevOps-anatoly"
terraform --environment production --region eu-west-1 import 'module.sso.aws_identitystore_group_membership.aws_membership["AWSDevOps-anatoly"]' d-12345fai6g/$membership_id
echo "FINISHED! imported AWSDevOps-anatoly"
echo "STARTED... importing AWSLegacyViewers-nissim"
terraform --environment production --region eu-west-1 import 'module.sso.aws_identitystore_group_membership.aws_membership["AWSLegacyViewers-nissim"]' d-12345fai6g/$membership_id
echo "FINISHED! imported AWSLegacyViewers-nissim"
echo "STARTED... importing AWSLegacyViewers-anatoly"
terraform --environment production --region eu-west-1 import 'module.sso.aws_identitystore_group_membership.aws_membership["AWSLegacyViewers-anatoly"]' d-12345fai6g/$membership_id
echo "FINISHED! imported AWSLegacyViewers-anatoly"
echo "STARTED... importing AWSLegacyViewers-kochava-shavit"
terraform --environment production --region eu-west-1 import 'module.sso.aws_identitystore_group_membership.aws_membership["AWSLegacyViewers-kochava-shavit"]' d-12345fai6g/$membership_id
echo "FINISHED! imported AWSLegacyViewers-kochava-shavit"
echo "STARTED... importing AWSBillingViewers-nissim"
terraform --environment production --region eu-west-1 import 'module.sso.aws_identitystore_group_membership.aws_membership["AWSBillingViewers-nissim"]' d-12345fai6g/$membership_id
echo "FINISHED! imported AWSBillingViewers-nissim"

