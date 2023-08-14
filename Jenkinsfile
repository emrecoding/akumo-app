def userIdCEO = slackUserIdFromEmail('SlackProfileEmail@domain.com')

def determineEnvName(BRANCH_NAME) {
    return ['develop': 'dev', 'stage': 'stg', 'main': 'prd'].get(BRANCH_NAME)
}

pipeline {
    agent any
    parameters {
        choice(
            choices: ['plan', 'apply', 'destroy'],
            description: 'Terraform action selection',
            name: 'SELECT_CHOICE'
        )
    }
    
    stages {
        stage('Environment maps') {
            steps {
                script {
                    env.ENV_NAME = determineEnvName(env.BRANCH_NAME)
                }
            }
        }

        stage('Terraform initialization') {
            steps {
                dir("akumo_app") {
                    sh "terraform init -backend-config=key=akumo_app/${env.ENV_NAME}/terraform.state"
                }
            }
        }

        stage('Terraform validation and format') {
            steps {
                dir("akumo_app") {
                    sh "terraform fmt"
                    sh "terraform validate"
                }
            }
        }

        stage('Terraform executing action') {
            steps {
                echo "Executing selected terraform action(s) ${params.SELECT_CHOICE}"
                dir("akumo_app") {
                    script {
                        def varFile = "tfvars/${env.ENV_NAME}.tfvars"
                        switch(params.SELECT_CHOICE) {
                            case 'plan':
                                sh "terraform plan -var-file=${varFile}"
                                break
                            case 'apply':
                                sh "terraform plan -var-file=${varFile}"
                                sh "terraform apply -auto-approve -var-file=${varFile}"
                                break
                            case 'destroy':
                                sh "terraform destroy -auto-approve -var-file=${varFile}"
                                break
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo '### Send slack notification ###'
            slackSend(color: "good", message: "<@$userIdCEO> akumo_app_cicd pipeline status: STABLE")
        }
        failure {
            echo '### Send slack notification ###'
            slackSend(color: "danger", message: "<@$userIdCEO> akumo_app_cicd pipeline status: CRITICAL FAILURE")
        }
        always {
            echo '### Clean Workspace ###'
            cleanWs()
        }
    }
}
