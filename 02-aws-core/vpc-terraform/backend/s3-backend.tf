terraform {
  backend "s3" {
    bucket       = "gabi-terraform-state"
    key          = "phase2/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}