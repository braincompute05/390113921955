data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "eks-training2024-terraform-state-main"
    key    = "eks-training01/dev/vpc.tfstate"
    region = "us-east-1"
  }
}