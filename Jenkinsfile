pipeline {
    agent any

    // triggers {
    //     cron('H/30 * * * *')   // Runs every 30 minutes
    // }

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

        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                dir('terraform') {
                    echo "Running Terraform plan..."
                    sh 'terraform plan'

                    echo "Applying Terraform changes..."
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                dir('terraform') {
                    echo "Destroying Terraform resources..."
                    sh 'terraform destroy -auto-approve'
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