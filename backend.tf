terraform {
  required_version = ">= 0.12.2"

  backend "s3" {
    region         = "us-east-2"
    bucket         = "uncommon-vibe-test3-app-state"
    key            = "terraform.tfstate"
    dynamodb_table = "uncommon-vibe-test3-app-state-lock"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}
