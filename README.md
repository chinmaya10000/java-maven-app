Create ECR Repository

Create Credentias in Jenkins(username and password)
 user=AWS
 password=aws ecr get-login-password --region us-east-2(command to get password) 

Create secret for AWS ECR
 kubectl create secret docker-registry aws-registry-key --docker-server=810652276964.dkr.ecr.us-east-2.amazonaws.com --docker-username=AWS --docker-password=aws ecr get-login-password --region us-east-2

 Update Jenkinsfile