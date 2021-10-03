#!/bin/bash
sudo apt-get update
sudo apt-get install python3  awscli wget unzip python3-pip -y
sudo pip3 install Flask

# Start the Flask App.
aws s3 cp  s3://app_artifact_bucket/vtagname.zip .
sudo unzip vtagname.zip
cd flask-spa
python3 main.py
