#!/bin/bash
sudo wget https://releases.hashicorp.com/terraform/0.12.0/terraform_0.12.0_linux_amd64.zip
sudo apt-get update; apt-get install awscli unzip zip dos2unix  -y
sudo unzip terraform_0.12.0_linux_amd64.zip
chmod +x terraform
cp terraform app/
mkdir /root/.aws/
echo "[default]"  >> /root/.aws/credentials
cd backend
sed -i "s/aws-region/$aws_region/g" variable.tf
sed -i "s/terraform_state_bucket/$terraform_state_bucket/g" backend.tf
sed -i "s/terraform_state_bucket/$terraform_state_bucket/g" bucket_check.sh
sed -i "s/app_artifact_bucket/$app_artifact_bucket/g"       bucket_check.sh
sed -i "s/app_artifact_bucket/$app_artifact_bucket/g"       backend.tf
chmod +x bucket_check.sh
./bucket_check.sh
