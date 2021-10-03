# Web App Deployment on AWS EC2 Instance (Blue Green Deployment)

This step-by-step tutorial explains how to deploy Python Web App using Jenkins **on AWS EC2 Instance**. I have used **Blue Green Deployment strategy**.

This setup is very similar to the other setup in which I used an ECS cluster to deploy the Web App and here is the [link](https://github.com/rsthakur83/spay.git) to it.

**I have tested this setup on AWS region `us-east-1` and also the terraform variable.tf file has values set as per the region `us-east-1` so i recommend to use the same region**.

- [Web App Deployment on AWS EC2 Instance (Blue Green Deployment)](#web-app-deployment-on-aws-ec2-instance-blue-green-deployment)
  - [**Jenkins Pipeline**](#jenkins-pipeline)
  - [**Prerequisites**](#prerequisites)
  - [**Jenkins Pipeline Stages**](#jenkins-pipeline-stages)  
    - [**SAST**](#sast)
    - [**Dependency Check Vulnerability**](#dependency-check-vulnerability)
    - [**Create Terraform State Bucket and Artifact Bucket**](#create-terraform-state-bucket-and-artifact-bucket)
    - [**Dynamic Application Security Testing**](#dynamic-application-security-testing)
    - [**Build Artifact and Push to S3**](#build-artifact-and-push-to-s3)
    - [**Create Two Tier Architecture and Blue Green Deployment**](#create-two-tier-architecture-and-blue-green-deployment)


- [**Web App Two Tier Architecture on AWS ECS Cluster**](#web-app-two-tier-architecture-on-aws-ecs-cluster)

    Let’s go through each of the tiers:
    - [**Tier 1: Public access - Application Load balancer**](#tier-1-public-access---application-load-balancer)
    - [**Tier 2: Restricted access - ECS Containers Running in private subnet**](#tier-2-restricted-access---ecs-containers-running-in-private-subnet)
    
- [**Access Web Application**](#access-web-application)

## **Jenkins Pipeline**

This section explains the prerequisite for setting up ci/cd pipeline using jenkins for Web App running on AWS ECS Cluster.

## **Jenkins Pipeline Stages**

![pipeline-stages.PNG](images/ec2-ci-cd.PNG)

## **Prerequisites**

- First, create a new repository on your github account and clone this repo

- I have used debian 10 OS to install Jenkins, you can use any OS but make sure packages mentioned in the next section are installed on it and after jenkins install add below plugins:

        - Pipeline: AWS Steps
        - Pipeline
        - AWS Secrets Manager Credentials Provider
        - Credentials Plugin
        - Credentials Binding Plugin 
- Install python **bandit**, **trivy** and **owasp zap**

- Secondly, make the following changes in the **Jenkinsfile** of this repo as per your requirement and environment:
  
      - app_artifact_bucket = "app-artifact-bucket-spay"                                                // S3 bucket to store Artifact
      - terraform_state_bucket = "terraform-state-file-storage-surepay"    // S3 bucket to store terraform state file

## **SAST**

This is the first stage of the Jenkins pipeline and in this stage python application code will be scanned **(SAST)** to find OWASP Top 10 vulnerabilities

## **Dependency Check Vulnerability**

This stage checks installed dependencies for known vulnerabilities

## **Create Terraform State Bucket and Artifact Bucket**

After passing both SAST and vulnerability scan, it creates bucket to store terraform state file and artifact of the application which is pulled by userdata script of EC2 instance.

## **Dynamic Application Security Testing**

This stage uses OWASP ZAP to performs dynamic application security testing (DAST) tool to find vulnerabilities in python web applications.

## **Build Artifact and Push to S3**

In the 6th stage it create the artifact and pushes it to artifact bucket created in the 4th stage.

## **Create Two Tier Architecture and Blue Green Deployment**

In the last stage of pipeline it creates two tier architect on AWS which is mentioned below in detail and performs **blue green deployment** whenever there is commit in the git repo.

## **Web App Two Tier Architecture on AWS ECS Cluster**

![ec2.PNG](images/aws-ec2.PNG)

## **Tier 1: Public access - Application Load balancer**

Tier1 is publicly accessible and it has two subnets(ip address range 10.0.5.0/24 & 10.0.6.0/24) spread across two availability zone (us-east-1a, us-east-1b). Application load balancer (ALB) gets deployed in a public subnet so that end user can access application from internet. To achieve high availability for the application two NAT gateway will also be get deployed in each of these public subnets. Application load balancer listens on a port 80 and forwards the traffic to the backend instances running in tier2 at port 5000. Application load balancer target group configured to perform a health check of backend at port 5000 on the path /.

## **Tier 2: Restricted access - ECS Containers Running in private subnet**

Tier2 also consists of two private subnets (IP address range 10.0.3.0/24 & 10.0.4.0/24) with a NAT gateway attached to the routes associated with these subnets so that instances running in the private subnet can reach the internet. Application instances running in the private subnets are managed/launched under the autoscaling group. Cloudwatch monitoring enabled and configured for scale Out & scale In of the instance based on CPU metrics. These instances registered themselves under the target group which is attached to the ALB. Application security group ingress rule on the private subnet only allows traffic from the load balancer security group at port 5000..

## **Access Web Application**

To access the web application go to the load balancer section on the EC2 of AWS console and enter the dns name of load balancer (http://ecsloadbalancer-1066686613.us-east-1.elb.amazonaws.com/) in your browser and you will see something like below.
![webapp.PNG](images/webapp.PNG)
