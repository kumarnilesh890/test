pipeline {
    agent any

    environment {
        S3_BUCKET = "my-jenkins-artifacts-bucket"
        AWS_REGION = "us-east-1"
    }

    stages {

        stage('Checkout from GitHub') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/your-username/your-repo.git'
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
