pipeline {
    agent any
    environment {
        aws_region = "us-east-1"
        terraform_state_bucket = "terraform-state-file-storage-surepay-ec2"
 	app_artifact_bucket = "app-artifact-bucket-spay"
 	image_ami_id	    = "ami-042e8287309f5df03"
	tag_name = sh(script: 'git tag --sort=-creatordate | head -n 1', returnStdout: true).trim()
        }
    stages {

        stage('Bandit Code Analysis SAST') {
             steps {
   		sh '''echo Building "$tag_name"'''
   		sh '''echo Building "$tag_name"'''
                 
                 sh "cd flask-spa/;docker run --rm --volume \$(pwd) secfigo/bandit:latest"
        }
     }
   

	stage ("Dependency Check with Python Safety"){
         	steps{
	        	sh "docker run --rm --volume \$(pwd) pyupio/safety:latest safety check"
			sh "docker run --rm --volume \$(pwd) pyupio/safety:latest safety check --json > report.json"
			}
		}
        
      
        stage('Create Terraform State File Bucket and Artifact Bucket') {
            steps {
                withAWS(credentials: 'aws-credential', region: 'us-east-1') {
                    sh 'chmod +x bucket.sh'
                    sh "./bucket.sh"
                }
              }
            }


        stage('Dynamic Application Security Testing DAST') {

      steps {

                withAWS(credentials: 'aws-credential', region: 'us-east-1') {
                     sh "chmod +x dast.sh start_app.sh"
		     sh "./start_app.sh"
                     sh "./dast.sh"

        }
      }
    }


        stage('Build Artifact and Push to S3') {
            steps {
                withAWS(credentials: 'aws-credential', region: 'us-east-1') {
                    sh 'chmod +x build_push.sh'
                    sh "./build_push.sh"
                    
                }
	      }
            }            


        stage('Create Two Tier Arch on AWS and Blue Green Deployment') {
            steps {
                withAWS(credentials: 'aws-credential', region: 'us-east-1') {
                    sh "chmod +x aws_tier.sh"
                    sh "./aws_tier.sh"
                }
              }
            }

    }

    post {
        always {
            cleanWs()
        }
    success {
      mail to: "surepay@gmail.com", subject:"SUCCESS: ${currentBuild.fullDisplayName}", body: "Yay, we passed."
    }
    failure {
      mail to: "surepay@gmail.com", subject:"FAILURE: ${currentBuild.fullDisplayName}", body: "Ohhhh, we failed."
    }

  }
}
