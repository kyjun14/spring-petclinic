pipeline {
  agent any
  tools {
    maven 'M3'
    jdk 'JDK11'
  }
  environment {
    AWS_CREDENTIALS_NAME = "AWSCredentials"
    REGION = "ap-northeast-2"
    DOCKER_IMAGE_NAME = "project01-spring-petclinic"
    DOCKER_TAG = "1.0"
    S3_BUCKET = "project01-terraform-state"
    APPLICATION_NAME = 'project01-production-in-place'
    ECR_REPOSITORY = "257307634175.dkr.ecr.ap-northeast-2.amazonaws.com/project01-spring-petclinic"
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
      post {
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
          sh 'rm -f ~/.dockercfg ~/.docker/config.json || true' 

          docker.withRegistry("https://${ECR_REPOSITORY}", "ecr:${REGION}:${AWS_CREDENTIALS_NAME}") {
            docker.image("${DOCKER_IMAGE_NAME}:${DOCKER_TAG}").push()
          }
        }
      }
    }

    stage('Upload to S3') {
      steps {
        dir("${env.WORKSPACE}") {
          sh 'zip -r deploy-1.0.zip ./scripts appspec.yml'
          sh 'aws s3 cp --region ap-northeast-2 --acl private ./deploy-1.0.zip s3://${S3_BUCKET}'
          sh 'rm -rf ./deploy-1.0.zip'
        }
      }
    }

    stage('Create Codedeploy Applicatation') {
      steps {
        script {
          sh 'aws deploy create-application --application-name "${APPLICATION_NAME}" --compute-platform "Server"'
        }        
      }
    }
  }  
}
