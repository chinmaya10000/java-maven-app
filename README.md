# Ansible integration in Jenkins

1. Create a server for jenkins
2. Create a dedicated server for ANsible
3. Execute Ansible playbook from jenkins pipeline to configure 2 EC2 instances

plugin: ssh pipeline step

# vim ~/.aws/credentials
 [default]
 aws_access_key_id = your-access-key-id
 aws_secret_access_key = your-secret-access-key