terraform {
  backend "s3" {
    bucket       = "vijay-aws-terraform-project"
    key          = "aws-terraform-project/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}