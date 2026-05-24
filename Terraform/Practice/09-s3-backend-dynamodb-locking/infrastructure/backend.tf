terraform {
  backend "s3" {
    bucket         = "zenithra-terraform-state-demo"
    key            = "practice/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
  }
}
