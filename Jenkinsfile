pipeline {
  agent any
  tools {
    maven 'M3'
    jdk 'JDK11'
  }

  stages {
    stage('Git Clone') {
      steps {
        git url 'https://github.com/kyjun14/spring-petclinic.git', branch: 'efficient-webjars', credentialsId: 'GitCredentials'
      }
    }
  }
}
