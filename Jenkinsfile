pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        S3_BUCKET  = "my-jenkins-artifacts-bucket-s3"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Upload Terraform Code to S3') {
            steps {
                sh '''
                  aws s3 cp terraform/ s3://${S3_BUCKET}/terraform-code/ --recursive
                '''
            }
        }
    }

    post {
        success {
            echo "EC2 created and Terraform code uploaded to S3 🚀"
        }
        failure {
            echo "Pipeline failed ❌"
        }
    }
}
