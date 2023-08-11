Install kubectl command line tool 
# curl -LO https://dl.k8s.io/release/v1.27.4/bin/linux/amd64/kubectl
# chmod +x kubectl
# kubectl version --client

Download and install eksctl using curl:
# sudo curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

# sudo mv /tmp/eksctl /usr/local/bin

# eksctl version

To install aws-iam-authenticator
# curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator

# chmod +x aws-iam-authenticator
# mv aws-iam-authenticator /usr/local/bin/
# aws-iam-authenticator version

To create an Amazon EKS (Elastic Kubernetes Service) cluster using eksctl
# eksctl create cluster \
  --name <cluster-name> \
  --region <region> \
  --nodegroup-name <nodegroup-name> \
  --node-type <instance-type>  \
  --nodes <desired-node-count>\
  --node-min 1 \
  --node-max 3


Install kubectl command line tool inside Jenkins container
# Set the desired version of kubectl
   VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
# Download and install kubectl
   sudo curl -LO "https://storage.googleapis.com/kubernetes-release/release/${VERSION}/bin/linux/amd64/kubectl"

# sudo chmod +x kubectl
# sudo mv kubectl /usr/local/bin/

Install aws-iam-authenticator tool inside Jenkins container
# curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/   aws-iam-authenticator
# chmod +x aws-iam-authenticator
# mv aws-iam-authenticator /usr/local/bin/
# aws-iam-authenticator version

Create kubeconfig file to connect to EKS

Add AWS credentials on Jenkins for AWS account authentication

Adjust Jenkinsfile to configure EKS cluster deployment


#######################################################################################################################
Install "gettext-base" tool inside Jenkins container
# docker exec -it <container_name_or_id> /bin/bash
# apt-get update
# apt-get install gettext-base

#####################################################
Create Secret for DockerHub Credentials(inside eks cluster)
# kubectl get nodes
# kubectl create secret docker-registry my-registry-key \
  --docker-server=docker.io \
  --docker-username=<DockerHub username> \
  --docker-password=<dockerHub password>

# kubectl get secret