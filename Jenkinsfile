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
            description: 'Select apply to create/update or destroy to delete resources'
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
                            sh 'terraform plan'
                            sh 'terraform apply -auto-approve'
                        } else if (params.ACTION == 'destroy') {
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
                sh """
                aws s3 cp ../terraform/ s3://${S3_BUCKET}/terraform-code/ --recursive
                """
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
