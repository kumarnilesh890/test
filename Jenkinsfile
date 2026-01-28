pipeline {
    agent any

    environment {
        S3_BUCKET  = "my-jenkins-artifacts-bucket-s3"
        AWS_REGION = "ap-south-1"
    }

    parameters {
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'Select "apply" to create/update resources or "destroy" to delete them'
        )
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

        stage('Terraform Plan/Apply/Destroy') {
            steps {
                dir('terraform') {
                    script {
                        if (params.ACTION == 'apply') {
                            echo "Running Terraform plan and apply..."
                            sh 'terraform plan'
                            sh 'terraform apply -auto-approve'
                        } else if (params.ACTION == 'destroy') {
                            // Manual confirmation in Jenkins UI
                            input message: "⚠️ Are you sure you want to destroy all resources?"
                            echo "Destroying Terraform resources..."
                            sh 'terraform destroy -auto-approve'
                        }
                    }
                }
            }
        }

        stage('Upload Terraform Code to S3') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                dir('terraform') {
                    sh "aws s3 cp . s3://${S3_BUCKET}/terraform-code/ --recursive"
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline finished successfully 🎉"
        }
        failure {
            echo "Pipeline failed ❌"
        }
    }
}
