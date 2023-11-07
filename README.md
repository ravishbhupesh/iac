# IAC

## Modules
- iac-tf-base

This module contains the terraform scripts to create the resources.

### Sub-Modules

- elasticache

This module contains the terraform scripts to create Elacticache resource.

- lambda

This module contains the terraform scripts to create a lambda function.

- api gateway

This module contains the terraform scripts to create Rest API with Api Gateway.

## How to run after checking out first time?


### pre-requisites
You need to configure the aws cli on your machine.

### Terraform Commands
### Run below commands from the iac-tf-base folder

1. terraform init

Initializes the project with terraform related modules based on the information present in the tf files.

2. terraform fmt

Formats all files in the directory

3. terraform validate

Validates the tf files

4. terraform plan -out "base.tfplan"

Created the plan to create the infrastructure.

5. terraform apply "base.tfplan"

Creates the infrastructure

6. terraform destroy

Destroys the existing ifnrastructure

### This project uses terraform workspaces

VPC and other related resources will be created based on the workspace. Following maps of workspaces are available

- default
- dev
- uat
- prod

### The resources will be created based on the values provided in the "input-template.json" file
