pipeline {
  agent any
  tools {
    maven 'M3'
    jdk 'JDK11'
  }

  stages {
    stage('Git Clone') {
      steps {
        git url '', branch: 'efficient-webjars', credentialsId: 'GitCredentials'
      }
    }
  }
}
