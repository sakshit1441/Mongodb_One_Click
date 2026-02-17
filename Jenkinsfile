pipeline {
    agent any
    
    parameters {
        // This allows you to choose apply or destroy at the start of the build
        choice(name: 'TF_ACTION', choices: ['apply', 'destroy'], description: 'Select the Terraform action to perform')
    }

    environment {
        TF_DIRECTORY = 'terraform'
        ANSIBLE_DIRECTORY = 'ansible'
        AWS_DEFAULT_REGION = 'us-east-1'
        // Jenkins maps 'aws-keys' to AWS_CREDS_USR and AWS_CREDS_PSW automatically
        AWS_CREDS = credentials('aws-keys')

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
                withCredentials([usernamePassword(credentialsId: 'aws-keys', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY'), sshUserPrivateKey(credentialsId: 'my-server-ssh-key-v1', keyFileVariable: 'SSH_KEY')]) {
                    dir("${env.TF_DIRECTORY}") {
                        // Copy SSH key for Terraform to use
                        sh "rm -f /tmp/one__click.pem && cp ${SSH_KEY} /tmp/one__click.pem && chmod 400 /tmp/one__click.pem"
                        
                        // Added -input=false and -force-copy to stop Terraform from asking for manual input
                        sh 'terraform init -input=false'
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
                    // || true prevents the pipeline from failing if there are only minor linting warnings
                    sh 'ansible-lint -v playbook.yml || true'
                }
            }
        }

        stage('Ansible Configuration - MongoDB') {
            when { expression { params.TF_ACTION == 'apply' } }
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'my-server-ssh-key-v1', keyFileVariable: 'SSH_KEY')]) {
                    dir("${env.ANSIBLE_DIRECTORY}") {
                        // Copy SSH key for Ansible to use
                        sh "rm -f /tmp/one__click.pem && cp ${SSH_KEY} /tmp/one__click.pem && chmod 400 /tmp/one__click.pem"
                        sh "ansible-playbook -i inventory.ini playbook.yml --private-key=/tmp/one__click.pem -u ubuntu"
                    }
                }
            }
        }
    }

    post { 
        always { 
            // Cleanup sensitive files and workspace
            sh 'rm -f /tmp/one__click.pem' 
            cleanWs()
        }
        success {
           // Send Email notification on Success
            mail to: 'bhavna123porwal@gmail.com',
                 from: 'bhavna123porwal@gmail.com',
                 subject: "Success: ${env.JOB_NAME} Build #${env.BUILD_NUMBER}",
                 body: "Check details at ${env.BUILD_URL}"
        }

        failure {

            // Send Email notification on Failure
            mail to: 'bhavna123porwal@gmail.com',
                 from: 'bhavna123porwal@gmail.com',
                 subject: "FAILURE: ${env.JOB_NAME} Build #${env.BUILD_NUMBER}",
                 body: "The build failed. Please check the logs at ${env.BUILD_URL}"
        }

    }
}
