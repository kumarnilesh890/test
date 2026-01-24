pipeline {
    agent any

    environment {
        S3_BUCKET  = "my-jenkins-artifacts-bucket-s3"
        AWS_REGION = "us-east-1"
    }

    stages {

        stage('Verify files') {
            steps {
                sh 'ls -l'
            }
        }

        stage('Upload to S3') {
            steps {
                sh '''
                  aws s3 cp data/ s3://${S3_BUCKET}/ --recursive
                '''
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
