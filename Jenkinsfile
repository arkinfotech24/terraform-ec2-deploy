pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ROLE_ARN = 'arn:aws:iam::<ACCOUNT_ID>:role/terraform-deploy-role'
        SESSION_NAME = 'jenkins-terraform-session'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/arkinfotech24/terraform-ec2-deploy.git', branch: 'master'
            }
        }

        stage('Assume Role') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'sts-user-creds'
                ]]) {
                    script {
                        def credsJson = sh(
                            script: """
                            aws sts assume-role \
                              --role-arn "$ROLE_ARN" \
                              --role-session-name "$SESSION_NAME" \
                              --region "$AWS_REGION" \
                              --output json
                            """,
                            returnStdout: true
                        ).trim()

                        def json = readJSON text: credsJson

                        env.AWS_ACCESS_KEY_ID     = json.Credentials.AccessKeyId
                        env.AWS_SECRET_ACCESS_KEY = json.Credentials.SecretAccessKey
                        env.AWS_SESSION_TOKEN     = json.Credentials.SessionToken
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            when {
                branch 'master'
            }
            steps {
                input message: 'Approve Terraform Apply?', ok: 'Apply'
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        failure {
            echo 'Terraform pipeline failed.'
        }
    }
}
