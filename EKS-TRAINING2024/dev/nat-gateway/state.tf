terraform {
  backend "s3" {
    bucket = "eks-training2024-terraform-state-main"
    key    = "eks-training01/dev/nat-gateway/natgateway.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}