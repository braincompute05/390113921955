resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.product-name}-eks-${var.envirnoment}-cluster"
  version  = "1.26"
  role_arn = aws_iam_role.eks_role.arn
  vpc_config {
    subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
    security_group_ids = [aws_security_group.allow_all_inbound.id]
  }
}


resource "aws_eks_node_group" "managed_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.product-name}-eks-${var.envirnoment}-cluster-managed-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = data.terraform_remote_state.vpc.outputs.private_subnets

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }
/*
  launch_template {
    id      = aws_launch_template.eks-launch-template.id
    version = "$Latest"
  }
*/
  remote_access {
    ec2_ssh_key = "eks-key-pair"
  }

  tags = {
    "Name" = "my-eks-node-group"
    "kubernetes.io/cluster/my-eks-cluster" = "owned"
  }

  instance_types = [var.node_group_instance_type]
}

resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "cni_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_security_group" "allow_all_inbound" {
  name        = "allow_all_inbound"
  description = "Security group with inbound rules open for all traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id  # Replace with your VPC ID

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_inbound"
  }
}

/*
resource "aws_launch_template" "eks-launch-template" {
  name          = "eks-launch-template"
#  user_data = filebase64("${path.module}/user-data.sh")
   user_data = base64encode("user_data.sh")
#  user_data = "${file("/home/shiva/gitcode/eks-cluster/390113921955/EKS-TRAINING2024/dev/eks/user-data.sh")}"
}


data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")
}

*/