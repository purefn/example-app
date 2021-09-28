terraform {
  required_version = ">= 0.12.2"

  backend "s3" {
    region         = "us-east-2"
    bucket         = "example-app-test-app-state"
    key            = "terraform.tfstate"
    dynamodb_table = "example-app-test-app-state-lock"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}
