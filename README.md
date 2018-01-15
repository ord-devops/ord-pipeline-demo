# ord-pipeline-demo
CI/CD pipeline to kubernetes cluster in AWS

# Usage
## Terraform
To create terraform resources, please first install terraform and terragrunt (from gruntworks.io). Terragrunt allows for automated backend management amongst other useful features for working with terraform in teams.

go to the terraform/<resource> folder and then type:
	terragrunt init   # to initalise the backend
	terragrunt get --update # to handle any module changes in this version
	terragrunt plan # to see what terraform will create/destroy/update
	terragrunt apply # to apply the changes
	
