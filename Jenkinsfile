pipeline {
  agent any
  tools {
    maven 'M3'
    jdk 'JDK11'
  }
  environment {
    AWS_CREDENTIALS_NAME = "AWSCredentials"
    REGION = "ap-northeast-2"
    DOCKER_IMAGE_NAME = "aws13-spring-petclinic"
    DOCKER_TAG = "1.0"
    ECR_REPOSITORY = "257307634175.dkr.ecr.ap-northeast-2.amazonaws.com"
    ECR_DOCKER_IMAGE = "${ECR_REPOSITORY}/${DOCKER_IMAGE_NAME}"
    ECR_DOCKER_TAG = "${DOCKER_TAG}"
  }

  stages {
    stage('Git Clone') {
      steps {
        git url: 'https://github.com/kyjun14/spring-petclinic.git', branch: 'efficient-webjars', credentialsId: 'GitCredentials'
      }
    }
    stage('mvn build') {
      steps {
        sh 'mvn -Dmaven.test.failure.ignore=true install'
      }
      post{
        success {
          junit '**/target/surefire-reports/TEST-*.xml'
        }
      }
    }
    stage('Docker Image Build') {
      steps {
        dir("${env.WORKSPACE}") {
          sh 'docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_TAG} .'
        }
      }
    }
    stage('Push Docker Image') {
      steps {
        script {
          

          docker.withRegistry("https://${ECR_REPOSITORY}", ecr:"${REGION}:${AWS_CREDENTIALS_NAME}") {
            docker.image("${ECR_DOCKER_IMAGE}:${ECR_DOCKER_TAG}").push()
          }
        }
      }
    }
  }
}
