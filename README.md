# exolyte-tf-ai
Uses Terraform to create AWS ECS instances for AI

# Terraform commands:
	terraform init
	terraform plan
	terraform apply
	terraform destroy

# Clean out Terraform directory and initialize
	rm .*.hcl terraform.tfstate terraform.tfstate.backup
	terraform init

# Check what Terraform will plan to do
	terraform plan

# Execute Terraform plan
	terraform apply

# Logging into AWS instance
	ssh ec2-user@<ip address>

# Destroy AWS asssets
	terraform destroy


