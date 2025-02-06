# Threat Modeling Tool App

Built on top of the Threat Composer Tool by Amazon (<https://awslabs.github.io/threat-composer/workspaces/default/dashboard>)

Repo used to deploy the app into AWS whether it's AWS ECS or EKS etc.

## Task/Assignment

- Your task will be to create a Dockerfile for it, push it to ECR.

- Deploy the app on ECS using Terraform.

- Make sure the app is live on `tm.<your-domain>` or `tm.labs.<your-domain>`

- App must use HTTPS. Hosted on ECS. Figure out the rest.

## Local app setup

```bash
yarn install
yarn build
yarn start
http://localhost:3000/workspaces/default/dashboard

## or
yarn global add serve
serve -s build

```
