
pipeline {
    agent any

    environment {
        AWS_REGION     = 'ap-south-1'
        AWS_ACCOUNT_ID = '429877855913'
        ECR_REPOSITORY = 'ecommerce-platform-dev'
        IMAGE_TAG      = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'E-Commerce DevOps Pipeline Started'
            }
        }

        stage('Verify Tools') {
            steps {
                sh 'git --version'
                sh 'docker --version'
                sh 'terraform --version'
                sh 'aws --version'
            }
        }

        stage('GitHub Code Pull') {
            steps {
               git 'https://github.com/hemant-harry/ecommerce-devops-platform.git'   }
        }

        stage('ECR Login') {
            steps {
                sh '''
                    set -e

                    aws ecr get-login-password \
                      --region "$AWS_REGION" |
                    docker login \
                      --username AWS \
                      --password-stdin \
                      "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    sh '''
                        set -e

                        docker build \
                          -t "$ECR_REPOSITORY:$IMAGE_TAG" .
                    '''
                }
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                    set -e

                    ECR_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY"

                    docker tag \
                      "$ECR_REPOSITORY:$IMAGE_TAG" \
                      "$ECR_URI:$IMAGE_TAG"

                    docker push "$ECR_URI:$IMAGE_TAG"
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    withCredentials([
                        string(
                            credentialsId: 'ecommerce-db-password',
                            variable: 'TF_VAR_db_password'
                        )
                    ]) {
                        sh '''
                            set -e

                            export TF_VAR_db_name="ecommerce"
                            export TF_VAR_db_username="my_db_user"
                            export TF_VAR_db_password_secret_arn="arn:aws:secretsmanager:ap-south-1:429877855913:secret:ecommerce-platform-dev/db-password-VLLQSR"

                            terraform init

                            terraform plan \
                              -var="image_tag=${IMAGE_TAG}" \
                              -out=tfplan
                        '''
                    }
                }
            }
        }

        stage('Deploy to ECS') {
            steps {
                dir('terraform') {
                    withCredentials([
                        string(
                            credentialsId: 'ecommerce-db-password',
                            variable: 'TF_VAR_db_password'
                        )
                    ]) {
                        sh '''
                            set -e

                            terraform apply -auto-approve tfplan
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Docker image pushed to ECR and Terraform deployment completed.'
        }

        failure {
            echo 'Pipeline failed. Check Console Output for the actual error.'
        }

        always {
            sh '''
                docker logout \
                  "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com" || true
            '''
        }
    }
}

