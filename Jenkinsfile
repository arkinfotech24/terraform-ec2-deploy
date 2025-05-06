pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-creds').accessKey
        AWS_SECRET_ACCESS_KEY = credentials('aws-creds').secretKey
        TF_VAR_region         = "us-east-1"
    }

    options {
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/arkinfotech24/terraform-ec2-deploy.git', branch: 'main'
            }
        }

        stage('Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Apply') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Approve apply?', ok: 'Apply'
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        success {
            echo 'Terraform apply succeeded!'
        }
        failure {
            echo 'Terraform pipeline failed.'
        }
    }
}
