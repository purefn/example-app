# You cannot create a new backend by simply defining this and then
# immediately proceeding to "terraform apply". The S3 backend must
# be bootstrapped according to the simple yet essential procedure in
# https://github.com/cloudposse/terraform-aws-tfstate-backend#usage
module "tfstate_backend" {
  source  = "cloudposse/tfstate-backend/aws"
  version = "0.32.0"

  attributes = ["state"]

  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend.tf"

  force_destroy                 = false
  prevent_unencrypted_uploads   = true
  enable_server_side_encryption = true

  context = module.this.context
}


