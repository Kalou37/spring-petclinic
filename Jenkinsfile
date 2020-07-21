pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                // Get some code from a GitHub repository
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [[$class: 'CheckoutOption', timeout: 5]],
                    submoduleCfg: [],
                    userRemoteConfigs: [[url: 'https://github.com/Kalou37/spring-petclinic.git']]
                    ])

                // Run Maven on a Unix agent.
                sh "mvn clean package"
            }

            post {

                // If Maven was able to run the tests, even if some of the test
                // failed, record the test results and archive the jar file.
                success {
                    archiveArtifacts artifacts: 'target/spring-petclinic-2.3.1.BUILD-SNAPSHOT.jar', followSymlinks: false
                }
                failure {
                    mail bcc: '', body: 'Tout est dans le titre', cc: '', from: '', replyTo: '', subject: 'Echec du build de la dernière version de PetClinic', to: 'p_roussel@hotmail.fr'
                }
            }
        }

        stage('Restart') {
            steps {
                sh label: '', script: '''sudo service petclinic stop
                rm -i -f /home/vagrant/petclinic/*.jar'''
                copyArtifacts filter: 'target/*.jar',
                flatten: true, projectName: 'PetClinic_Build',
                selector: lastSuccessful(),
                target: '/home/vagrant/petclinic/'
                sh label: '', script: '''mv /home/vagrant/petclinic/*.jar /home/vagrant/petclinic/petclinic.jar
                sudo chmod 777 /home/vagrant/petclinic/petclinic.jar
                sudo service petclinic start'''
            }
        }
    }
}
