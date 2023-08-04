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
            post {
                success {
                    echo 'success git clone'
                }
                failure {
                    echo 'failure git clone'
                }
            }
        }
        
        stage('Maven Build') {
            steps {
                sh 'mvn -Dmaven.test.failure.ignore=true clean package'
            }
            post {
                success {
                    junit '**/target/surefire-reports/TEST-*.xml'
                }
            }
        }
        
        stage('Docker Image Create') {
            steps {
                echo 'Docker Image Create'
            }
        }
        stage('Push Docker Image') {
            steps {
                echo 'Push Docker Image'
            }
        }
	
	stage('Deeploy') {
            steps {
                echo 'Deploy'
                sshPublisher(publishers: [sshPublisherDesc(configName: 'target', 
                transfers: [sshTransfer(cleanRemote: false, excludes: '', 
                execCommand: '''
                fuser -k 8080/tcp
                export BUILD_ID=Pipeline-PetClinic
                nohup java -jar /home/ubuntu/deploy/spring-petclinic-2.7.3.jar >> nohup.out 2>&1 &''', 
                execTimeout: 120000, 
                flatten: false, 
                makeEmptyDirs: false, 
                noDefaultExcludes: false, 
                patternSeparator: '[, ]+', 
                remoteDirectory: 'deploy', 
                remoteDirectorySDF: false, 
                removePrefix: 'target', 
                sourceFiles: 'target/*.jar')], 
                usePromotionTimestamp: false, 
                useWorkspaceInPromotion: false, verbose: false)])
            }            
        }
    }
}
