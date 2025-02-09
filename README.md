# EKS Project - Web App Deployment

This is the procedure I carried out to deploy a Threat model, Node.js Application alongside EKS IaC (Infrastructure As Code) where the pods for this application are hosted.
I will also go through the different tools that were used to streamline the process, such as ArgoCD, Helm, CI/CD pipelines as well as different linting and security tools I've used to maintain best practices.


<img src="Untitled video - Made with Clipchamp (2)-1.gif" width="700"/>

## Deployment

To deploy my project run

```bash
  git clone https://github.com/YD-git428/EKS-project.git
```

Feel free to edit your own credentials into the commented out sections within the main.tf file 

```bash
  cd main.tf
```
You can also configure your own Kubernetes manifest files within the apps folder (Where ArgoCD will detect the application that'll be hosted)

```bash
  cd apps
```
After making all necessary configurations run these commands:
```bash
  terraform init #Initialises your terraform configuration and state files.
```
```bash
  terraform validate #Ensure your configuration is valid.
```
```bash
  terraform plan #View what will be added, removed or changed when deploying your IaC.
```
```bash
  terraform apply #This will start the deployment process to match your desired state - you can use this to see if there are anymore underlying errors within your configuration.
```
## Docker

First I had to identify the dependencies necessary to run the application on my local machine. Once I knew what was needed to run the application, all that is left is to make a Docker file.

It was a multistage build this time, unlike my previous project where I hosted the same application. This saved up alot of storage consumption, resulting is smoother and efficient builds.

---
### Blocker:


1. I struggled with network timeouts when running yarn install as part of my Dockerfile

### Solution:

1. Run these commands then restart your terminal: 

```
clean npm cache
npm cache clean --force
set http_proxy=
Set https_proxy=
yarn config delete proxy
npm config rm https-proxy
npm config rm proxy
```
## Terraform

### I first delved into the fundementals of what is needed within an EKS Cluster:

- VPC with a minimum of 2 subnets
- NAT & Internet Gateway
- EKS Cluster
- Type of Node Group
- Security Groups
- IAM Roles & Policies for various resources

### Then I constructed the backbone of my IaC using AWS Documentation 

- I constructed a VPC with 6 subnets - 3 public and 3 private 
- A Route table, where I specified the route to my Internet Gateway from public subnets as well as the path to my NAT Gateway (situated in my public subnets) from my private subnets to have secure internet access.
- IAM Policy and Role definitions for my Cluster and worker nodes 

---
### Blocker

1. I configured my cluster to only accept public access via my personal public IP Address, this was a secure method I picked up after running `tfsec` to analyse my configuration for any vulnerabilities. However, later on I kept facing 'TLS' connection failiure errors when I deployed my custom resources & when connecting to my cluster via `kubectl`.

2. I struggled with `NodeCreationFailiure` because my instances failed to join my Cluster. As a result, my managed node groups kept on failing to form.

### Solution

1. I realised that my Public IP is dynamic, so I gave it a specific CIDR Range to allow flexibility.

2. I realised where the problem was after going through a series of deductions - the error ended up coming from my worker node security group. Sometimes the art of deduction is a great option when pinning down what is really causing the error to occur.

## Terraform (CRDs)

- Helm chart repositories were installed via the `helm release` resource block - Cert-manager, Argo-CD, External DNS, Nginx-ingress-controller.
- Created files within a `helm-values` directory that are the values associated with the `helm release` resource blocks. This is where I specified the job of each custom resource - best to read documentation on how to structure it based on your needs.
- Created a separate Argo-CD Application Manifest file where I specified my the source where ArgoCD will sync data from, as well as other syncing policies. - This is where GitOps comes in.
- Created a separate directory for my Cluster Issuer YML file - this is a resource that simplifies certification management by taking care of the issuing of multiple namespaces rather than having a separate issuer for each.
- Configured a bash script to install/delete Custom Resources and kubernetes namespaces to ensure a more graceful tear down once I destroy my infrastructure.

---
### Blockers

1. The ArgoCD Helm chart was 'not found' everytime I applied my configuration

2. My ArgoCD Hostname wasn't properly processed thus residing to the default `argo.example.com`. I came to the conclusion that the error was that my `secretName` was not being detected by my cert-manager.

### Solution

1. Using GitHub Community Chat & Stack Overflow helped—turns out, I had to ensure that none of my directory names matched the ArgoCD chart name... dont ask me why, I'm not sure myself.

2. For this one, I thank @Mustafa12z for his support in getting to the bottom of this. Funnily enough, he knew someone who dealt with a similar situation which is the importance of adding: 
```
global:
   domain: <your host>
```
After that I did some research on what 'global' means in the context of Helm?
                                        
To cut it short, global values are read by multiple charts without having to repeat yourself throughout - therefore, my cert-manager would manage to detect it and use the `secretName` to issue a certificate via my Cluster-issuer.

## CI/CD Pipelines

- I extracted the terraform pipeline from my previous End-End Project due to a very similar structure
- Added some refinements such as: Updating my kubeconfig; adding another IP address to my Cluster Public Endpoints (mid-apply) and topping it off with an `echo` command to automatically output the Argo-CD login credentials.
- I made a CI pipeline where I built and pushed my docker image to ECR
- Finally ended it with a Cleanup pipeline where I referenced my Cleanup script and basic `terraform destroy` workflow.
- I tested the pipeline out initially using nektos/act, then I proceeded to push it to my Github Action.

---
### Blockers:

1. My Helm resources + kubectl cli weren't able to connect to my kubernetes resource. This was because my GitHub Actions Runner has a separate set of dynamic IPs which means that it wont be accepted in my Cluster which has my personal public IPs as the only CIDR range that can publically access my cluster

2. The ingress controller created a Load Balancer by default and since it wasnt created by terraform, its not destroyed. Strangely enough, it was the security group created for the Load Balancer that was the issue.

3. (Silly) I had no clue why the terraform command wasn't found even though I tried all the tricks in the book to configure my path as I thought it couldn't find my terraform directory

### Solution:

1. Allow my terraform apply to fail by using `continue on error=true` then add a step where I use the AWS CLI to manually edit my Cluster configuration and add `$GITHUB_IP` as my other IP Address which is allowed access into my cluster. Finally, I repeated the apply process and the pipeline managed to complete.

2. This did require some researching but I also needed to interact with the AWS via the CLI to delete all security groups with a similar name.

3. I needed to install terraform as part of the pipeline. Yep that was all I needed to do.

## Conclusion

This project reinforced the importance of understanding each tool's fundamentals—from how ArgoCD syncs applications, to Helm’s values structure, and Fundementals of Kubernetes. Debugging challenges with networking, security, and CI/CD pipelines highlighted the need for research, structured troubleshooting, and leveraging community knowledge. Mastering these concepts is key to building scalable, secure, and automated deployments in modern DevOps. 🚀

