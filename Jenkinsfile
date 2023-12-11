pipeline {
    agent any
    environment {
        //be sure to replace "willbla" with your own Docker Hub username
        DOCKER_IMAGE_NAME = "mudgalK/train-schedule"
    }
    stages {
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh './gradlew build --no-daemon'
                archiveArtifacts artifacts: 'dist/trainSchedule.zip'
            }
        }
        stage('Build Docker Image') {
            //when {
            //    branch 'master'
            //}
            steps {
                script {
                    app = docker.build(DOCKER_IMAGE_NAME)
                    app.inside {
                        sh 'echo Hello, World!'
                    }
                }
            }
        }
        stage('Push Docker Image') {
            //when {
              //  branch 'master'
            //}
            steps {
                script {
                    docker.withRegistry(credentialsId: 'DOCKER_HUB_LOGIN', url: 'https://index.docker.io/v1/') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        
        stage('DeployToProduction') {
            //when {
             //   branch 'master'
            //}
            environment { 
                CANARY_REPLICAS = 0
            }
            steps {
              sh script: 'ansible-playbook --inventory /tmp/inv $WORKSPACE/deploy/deploy-kube.yml --extra-vars "env=prod build=$BUILD_NUMBER"'
            }
        }
    }
}
