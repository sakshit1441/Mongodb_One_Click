pipeline {
    agent any
    
    parameters {
        choice(
            name: 'TF_ACTION',
            choices: ['apply', 'destroy'],
            description: 'Select Terraform action'
        )
    }

    environment {
        TF_DIRECTORY = 'terraform'
        ANSIBLE_DIRECTORY = 'ansible'
        AWS_DEFAULT_REGION = 'ap-south-1'
        LANG = 'en_US.UTF-8'
        LC_ALL = 'en_US.UTF-8'
    }

    stages {

        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Infrastructure') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'aws-cred',
                        usernameVariable: 'AWS_ACCESS_KEY_ID',
                        passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                    ),
                    sshUserPrivateKey(
                        credentialsId: 'mongo-ssh-key',
                        keyFileVariable: 'SSH_KEY'
                    )
                ]) {
                    dir("${env.TF_DIRECTORY}") {

                        sh '''
                        export LANG=en_US.UTF-8
                        export LC_ALL=en_US.UTF-8

                        rm -f /tmp/mumbai_key
                        cp "$SSH_KEY" /tmp/mumbai_key
                        chmod 400 /tmp/mumbai_key

                        terraform init -input=false
                        '''

                        script {
                            if (params.TF_ACTION == 'apply') {
                                sh 'terraform apply -auto-approve -input=false'
                            } else {
                                sh 'terraform destroy -auto-approve -input=false'
                            }
                        }
                    }
                }
            }
        }

        stage('Ansible Lint') {
            when { expression { params.TF_ACTION == 'apply' } }
            steps {
                dir("${env.ANSIBLE_DIRECTORY}") {
                    sh '''
                    export LANG=en_US.UTF-8
                    export LC_ALL=en_US.UTF-8
                    ansible-lint -v playbook.yml || true
                    '''
                }
            }
        }

        stage('Ansible Configuration - MongoDB') {
            when { expression { params.TF_ACTION == 'apply' } }
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'mongo-ssh-key',
                        keyFileVariable: 'SSH_KEY'
                    )
                ]) {
                    dir("${env.ANSIBLE_DIRECTORY}") {

                        sh '''
                        export LANG=en_US.UTF-8
                        export LC_ALL=en_US.UTF-8

                        rm -f /tmp/mumbai_key
                        cp "$SSH_KEY" /tmp/mumbai_key
                        chmod 400 /tmp/mumbai_key

                        ansible-playbook -i inventory.ini playbook.yml \
                        --private-key=/tmp/mumbai_key \
                        -u ubuntu
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            sh 'rm -f /tmp/mumbai_key || true'
            cleanWs()
        }

        success {
            emailext(
                subject: "SUCCESS: ${env.JOB_NAME} Build #${env.BUILD_NUMBER}",
                body: """
                <h2 style="color:green;">Build Successful</h2>
                <p><b>Job:</b> ${env.JOB_NAME}</p>
                <p><b>Build Number:</b> ${env.BUILD_NUMBER}</p>
                <p><b>Action:</b> ${params.TF_ACTION}</p>
                <p><b>Build URL:</b> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                """,
                to: "sakshit1441@gmail.com",
                mimeType: 'text/html'
            )
        }

        failure {
            emailext(
                subject: "FAILURE: ${env.JOB_NAME} Build #${env.BUILD_NUMBER}",
                body: """
                <h2 style="color:red;">Build Failed</h2>
                <p><b>Job:</b> ${env.JOB_NAME}</p>
                <p><b>Build Number:</b> ${env.BUILD_NUMBER}</p>
                <p><b>Action:</b> ${params.TF_ACTION}</p>
                <p><b>Check Logs:</b> <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                """,
                to: "sakshit1441@gmail.com",
                mimeType: 'text/html'
            )
        }
    }
}
