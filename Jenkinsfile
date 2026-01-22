pipeline {
    agent any

    environment {
        S3_BUCKET = "my-jenkins-artifacts-bucket-s3"
        AWS_REGION = "us-east-1"
    }

    stages {

        stage('Checkout from GitHub') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/kumarnilesh890/test.git'
            }
        }

        stage('Verify files') {
            steps {
                sh 'ls -l'
            }
        }

        stage('Upload to S3') {
            steps {
                withAWS(credentials: 'aws-jenkins-creds', region: "${AWS_REGION}") {
                    sh '''
                    aws s3 cp data/ s3://$S3_BUCKET/data/ --recursive
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Upload to S3 completed successfully 🎉"
        }
        failure {
            echo "Upload failed ❌"
        }
    }
}
