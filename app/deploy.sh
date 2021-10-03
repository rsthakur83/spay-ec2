#!/bin/bash

lcfg1="APP-LC"
lcfg2="APP-LC-2"
asg="APP-ASG"
lc=`aws autoscaling describe-launch-configurations --region aws-region|grep LaunchConfigurationName|awk '{print $2}'|tail -1|cut -d '"' -f2`
tag_name=`git tag --sort=-creatordate | head -n 1`
sed -i  "s|tagname|$tag_name|g"    deploy/userdata-asg.sh
sed -i  "s|tagname|$tag_name|g"    lc1/userdata-asg.sh
sed -i  "s|tagname|$tag_name|g"    lc2/userdata-asg.sh

if [ "$lc" == "$lcfg1" ];then
	### Creating LC2 Lauch Config and Updating ASG
	echo "Creating LC2 Lauch Config and Updating ASG"
	cd lc2
	vpc=`aws ec2 describe-vpcs --filters Name=tag:Name,Values='SurePay App VPC' --query 'Vpcs[*].VpcId' --output text`
	sg=`aws ec2  describe-security-groups --filter Name=vpc-id,Values=$vpc  Name=tag:Name,Values='APP SG' --region aws-region --query 'SecurityGroups[*].[GroupId]' --output text`
	aws autoscaling create-launch-configuration --launch-configuration-name $lcfg2  --image-id ami-id --instance-type t2.micro --iam-instance-profile  cwdb_iam_profile --security-groups $sg  --user-data file://userdata-asg.sh
	aws autoscaling update-auto-scaling-group --auto-scaling-group-name $asg --launch-configuration-name $lcfg2 --min-size 4 --max-size 4
	sleep 150
	aws autoscaling update-auto-scaling-group --auto-scaling-group-name $asg --launch-configuration-name $lcfg2 --min-size 2 --max-size 3 --desired-capacity 2
	sleep 60
	aws autoscaling delete-launch-configuration --launch-configuration-name $lcfg1

elif [ "$lc" == "$lcfg2" ];then
	### Creating LC Lauch Config and Updating ASG
	echo "Creating LC Lauch Config and Updating ASG"
	cd lc1
	vpc=`aws ec2 describe-vpcs --filters Name=tag:Name,Values='SurePay App VPC' --query 'Vpcs[*].VpcId' --output text`
	sg=`aws ec2  describe-security-groups --filter Name=vpc-id,Values=$vpc  Name=tag:Name,Values='APP SG' --region aws-region --query 'SecurityGroups[*].[GroupId]' --output text`	
	aws autoscaling create-launch-configuration --launch-configuration-name $lcfg1  --image-id ami-id --instance-type t2.micro --iam-instance-profile  cwdb_iam_profile --security-groups $sg  --user-data file://userdata-asg.sh
	aws autoscaling update-auto-scaling-group --auto-scaling-group-name $asg --launch-configuration-name $lcfg1 --min-size 4 --max-size 4
	sleep 150
	aws autoscaling update-auto-scaling-group --auto-scaling-group-name $asg --launch-configuration-name $lcfg1 --min-size 2 --max-size 3 --desired-capacity 2
	sleep 60
	aws autoscaling delete-launch-configuration --launch-configuration-name $lcfg2

else
	### Creating Three Tier Architecture and deploying SurePay APP on AWS using terraform
        cd deploy;../terraform init;../terraform plan ;../terraform apply --auto-approve  #-var-file="var.tfvars" #-var-file="var.tfvars"
	sleep 120
fi
