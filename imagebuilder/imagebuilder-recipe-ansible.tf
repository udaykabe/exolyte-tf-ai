data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  tags       = module.tags.tags_no_name
}

module "tags" {
  # source = Terraform Module Registry reference
  source  = "rhythmictech/tags/terraform"
  version = "~> 1.1.1"

  names = [
    "BaaS",
    "imagebuilder",
    "backend"
  ]

  tags = {
    "Env"       = "uat",
    "Namespace" = "app",
    "Owner"     = "Backend Engineering Team"
  }
}

module "component_ansible_setup" {
  source  = "rhythmictech/imagebuilder-component-ansible-setup/aws"
  version = "~> 2.1.0"

  component_version = "1.0.0"
  description       = "Ansible Installer"
  name              = "ansible-installer"
  tags              = local.tags
}

module "component_ansible" {
  source  = "rhythmictech/imagebuilder-component-ansible/aws"
  version = "~> 3.1.0"

  component_version = "1.0.0"
  description       = "Ansible Playbook Runner"
  name              = "ansible-playbook-runner"
  tags              = local.tags
  playbook_repo     = "git::https://github.com/udaykabe/vagrant-dl.git"
}

module "exolyte_image_recipe" {
  source  = "rhythmictech/imagebuilder-recipe/aws"
  version = "~> 2.0.1"

  description    = "Recipe to build Exlolyte Linux 2 AMI"
  name           = "exolyte-linux2-recipe"
  parent_image   = "arn:aws:imagebuilder:us-east-1:aws:image/amazon-linux-2-x86/x.x.x"
  recipe_version = "1.0.0"
  tags           = local.tags
  update         = true

  component_arns = [
    module.component_ansible_setup.component_arn,
    module.component_ansible.component_arn,
    "arn:aws:imagebuilder:us-east-1:aws:component/simple-boot-test-linux/1.0.0/1",
    "arn:aws:imagebuilder:us-east-1:aws:component/reboot-test-linux/1.0.0/1"
  ]
}

module "exolyte_image_pipeline" {
  source  = "rhythmictech/imagebuilder-pipeline/aws"
  version = "~> 2.0.3"

  description      = "Exolyte Image Pipeline"
  name             = "xol-lnx2-pipeline"
  tags             = local.tags
  image_recipe_arn = module.exolyte_image_recipe.recipe_arn
  public           = false
}