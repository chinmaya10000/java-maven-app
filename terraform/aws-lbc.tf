provider "kubernetes" {
  host = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks.name]
    command = "aws"
  }
}

provider "helm" {
  kubernetes {
    host = aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command = "aws"
      args = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks.name]
    }
  }
}

data "aws_iam_policy_document" "aws_lbc" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
        "sts:AssumeRole",
        "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "aws_lbc" {
  name = "${aws_eks_cluster.eks.name}-aws-lbc"
  assume_role_policy = data.aws_iam_policy_document.aws_lbc.json 
}

resource "aws_iam_policy" "aws_lbc" {
  policy = file("./iam/AWSLoadBalancerController.json")
  name = "AWSLoadBalancerController"
}

resource "aws_iam_role_policy_attachment" "aws_lbc" {
  policy_arn = aws_iam_policy.aws_lbc.arn
  role = aws_iam_role.aws_lbc.name
}

resource "aws_eks_pod_identity_association" "aws_lbc" {
  cluster_name = aws_eks_cluster.eks.name
  namespace = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn = aws_iam_role.aws_lbc.arn
}

resource "helm_release" "aws_lbc" {
  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart = "aws-load-balancer-controller"
  version = "1.10.0"

  set {
    name = "clusterName"
    value = aws_eks_cluster.eks.name
  }

  set {
    name = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name = "vpcId"
    value = aws_vpc.main.id
  }

  depends_on = [ aws_eks_node_group.general ]
}