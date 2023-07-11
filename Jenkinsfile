pipeline {
  agent any
  tools {
    maven 'M3'
    jdk 'JDK11'
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
          sh 'docker build -t aws13-spring-petclinic:1.0 .'
        }
      }
    }
  }
}
