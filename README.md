# AWS-master-account

This Terraform stack has the role to manage the AWS master account `gili-master` :
* users management
* groups management
* accounts management
* permission sets management
* organization units management

## Requirements

### TerraForm

The stack require to use TerraForm >= 1.2.0

## Usage

```shell           
export AWS_PROFILE=123456789101_AWSAdministratorAccess
terraform --environment production --region eu-west-1 apply
```



