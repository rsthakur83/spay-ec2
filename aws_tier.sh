cd app
sed -i  "s|app_artifact_bucket|$app_artifact_bucket|g" deploy/userdata-asg.sh
sed -i  "s|aws-region|$aws_region|g" deploy/userdata-asg.sh
sed -i  "s|app-repo|$app_repo|g"  deploy/userdata-asg.sh
sed -i  "s|app_artifact_bucket|$app_artifact_bucket|g" deploy/iam_role_policy.tf
sed -i  "s|terraform_state_bucket|$terraform_state_bucket|g" deploy/terraform_backend.tf
sed -i  "s|aws-region|$aws_region|g" deploy/terraform_backend.tf
sed -i  "s|terraform_state_bucket|$terraform_state_bucket|g" lc1/lc.tf
sed -i  "s|aws-region|$aws_region|g" lc1/variables.tf
sed -i  "s|terraform_state_bucket|$terraform_state_bucket|g" lc2/lc.tf
sed -i  "s|aws-region|$aws_region|g"  lc2/variables.tf
sed -i  "s|aws-region|$aws_region|g"  deploy.sh
sed -i  "s|ami-id|$image_ami_id|g"    deploy.sh
sed -i  "s|ami-id|$image_ami_id|g"    lc1/variables.tf
sed -i  "s|ami-id|$image_ami_id|g"    lc2/variables.tf
cp deploy/userdata-asg.sh lc1/
cp deploy/userdata-asg.sh lc2/
chmod +x deploy.sh
echo "Execute deploy.sh"
sed -i  's/\r$//' deploy.sh
echo "Finished deploy.sh"
./deploy.sh
