pipeline {
    agent any
    
    stages {
        stage('Copy Files to EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2_key', keyFileVariable: 'keyfile')]) {
                    sh '''
                        ssh -i $keyfile -o StrictHostKeyChecking=no ubuntu@98.83.160.147 "rm -rf /home/ubuntu/depiii"
                        scp -i $keyfile -o StrictHostKeyChecking=no -r /var/lib/jenkins/workspace/depiii ubuntu@98.83.160.147:/home/ubuntu
                    '''
                }
            }
        }

        stage('Build, Push & Run Container') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ec2_key', keyFileVariable: 'keyfile')]) {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dockerpass', usernameVariable: 'dockeruser')]) {
                        sh 'ansible-playbook -i inventory.ini ansible-playbook.yml --private-key=$keyfile -e "docker_username=${dockeruser} docker_password=${dockerpass}"'
                    }
                }
            }
        }
    }

    post { 
        always { 
            script { 
                def emailNotification = load 'mail-notification.groovy'
                emailNotification.sendEmailNotification()
            } 
        } 
    } 
}
