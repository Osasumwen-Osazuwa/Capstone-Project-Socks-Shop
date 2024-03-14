Socks Shop Application

Today, we'll be deploying a 'Socks Shop' application on Kubernetes.

Tools:
. AWS
. GitHub
. GitLab

1. Choose an infrastucture as a service (Iaas) provider where your Kubernetes cluster will live. Amazon Web Services is the chosen provider for this project.

2. During this proccess, there are seven categories of files that will be created:
   1. Application Code
   2. Terraform Configuration
   3. Kubernetes Manifests
   4. Configuration
   5. IAM User Policy
   6. .gitlab-ci.yml
   7. Documentation

3. Create your terraform configuration files (main.tf, outputs.tf, variables.tf) with modules meeting your specific requirements.

4. Put your IAM User AWS credentials in a '.tfvars' file and encrypt it with Ansible Vault.

5. Create a bash script to decrypt the AWS credentials when you run your terraform configuration. The bash script will use the vault password so save it in a '.vault' file.

6. In your 'variables.tf' file, reference the AWS credential variables using the 'var' keyword followed by the variable name. For example: 'var.aws_credential'.

7. Run 'terraform init'.

8. Run 'terraform plan'.

9. After running 'terraform plan' you might get a note saying: 'You didn't use the -out option to save this plan so Terraform can't guarantee to take exactly these actions if you run 'terraform apply' now'.

10. To solve this, run 'terraform plan -out=tfplan'. This will create a snapshot of the planned configuration. (Be careful not to expose this snapshot because it will contain decrypted sensitive information.)

11. To apply the planned configuration, run 'terraform apply tfplan'.

12. You might get some errors saying 'Unauthorised Operation'. To fix these errors, edit your AWS IAM User Policy to include the necessary permissions.

13. Once your policy has been edited corectly, run 'terraform plan -out=tfplan' (to modify the planned configuration), then 'terraform apply tfplan' (to apply the modified configuration).

14. Your Kubernetes cluster has been successfully deployed.

15. Create your Kubernetes Manifests and split them into four categories: a.) Logging, b.) Monitoring, c.) Deployment, d.) Ingress
a.) The Logging directory should contain three manifests: 'fluentd-daemon', 'elasticsearch-stateful' and 'kibana'. Fluentd collects logs from application pods and sends them to Elasticsearch. Elasticsearch stores and indexes the log data. Kibana queries Elasticsearch to visualize and analyze the log data.
b.) The Monitoring directory should contain two manifests: 'alertmanager' and 'prometheus'.
c.) The Deployment directory should contain a deployment manifest.
d.) The Ingress directory should contain an ingress manifest.

16. Create your Configuration file and use Ansible Vault to encrypt your GitHub Personal Access Token(PAT).

17. Push all your project files to your GitHub repository.

18. Use GitLab to automate the build, test and deployment process.

19. Push the GitHub repository containing your project to your GitLab account.

20. In the root directory of your project on GitLab, create a file named '.gitlab-ci.yml'.

21. Within this file define stages such as 'plan', 'validate', 'apply' and 'deploy'.

22. Within each stage, define jobs to execute specific tasks such as terraform commands or deployment scripts.

23. Update the DNS settings for your domain to point to the public IP address of your Kubernetes cluster.