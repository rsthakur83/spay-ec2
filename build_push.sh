mkdir artifacts
echo ${tag_name}
echo ${tag_name}
zip -r v${tag_name}.zip flask-spa
cp v${tag_name}.zip artifacts
aws s3 cp artifacts/v${tag_name}.zip s3://${app_artifact_bucket}/
