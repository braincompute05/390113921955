terraform {
  backend "s3" {
    bucket = "eks-training2024-terraform-state-main"
    key    = "eks-training01/dev/eks01/eks.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}