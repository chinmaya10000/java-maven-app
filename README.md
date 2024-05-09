# Integrate Terraform in our CI/CD pipeline

Steps to Do
1. Create SSH Key-pair
2. Install TF inside Jenkins container
# apt-get update
# apt-get install -y curl unzip
# export TF_VERSION=1.8.3
# curl -LO "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip"
# unzip "terraform_${TF_VERSION}_linux_amd64.zip" -d /usr/local/bin
# rm "terraform_${TF_VERSION}_linux_amd64.zip"


3. Tf configuration to provision server
4. Adjust Jenkinsfile