# Import existing IAM role
data "aws_iam_role" "ku_learn_admin_role" {
  name = "AWS_IAM_ROLE"
}

# Attach EKS Cluster policy to the existing role
resource "aws_iam_role_policy_attachment" "my-project-eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = data.aws_iam_role.ku_learn_admin_role.name
}

resource "aws_iam_role_policy_attachment" "my-project-eks-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = data.aws_iam_role.ku_learn_admin_role.name
}

# Attach Node Group policies to the existing role
resource "aws_iam_role_policy_attachment" "eks-node-group-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = data.aws_iam_role.ku_learn_admin_role.name
}

resource "aws_iam_role_policy" "eks_inline_policy" {
  name = "eks-inline-policy"
  role = data.aws_iam_role.ku_learn_admin_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:Describe*",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          # Add required actions from AmazonEKS_CNI_Policy and ECR policy
        ],
        Resource = "*"
      }
    ]
  })
}

