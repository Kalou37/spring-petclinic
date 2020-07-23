pipeline {
    agent any

    stages {
        stage("Checkout SCM") {
            steps {
                checkout scm
            }
        }

        stage('Build Package') {
            steps {
                echo "### Start to build the JAR package..."
                sh "mvn -B jacoco:report checkstyle:checkstyle install"
            }

            post {
                success {
                    echo "### Build successful !"
                    archiveArtifacts artifacts: '**/target/spring-petclinic-*.jar', fingerprint: true
                }
                failure {
                    mail bcc: '', body: 'Tout est dans le titre', cc: '', from: '', replyTo: '', subject: 'Echec du build de la dernière version de PetClinic', to: 'p_roussel@hotmail.fr'
                    echo "### Build failed..."
                    error('Aborting the pipeline.')
                }
            }
        }

        stage('DockerImage') {
            steps {
                echo "### Delete old image docker..."
                sh label: 'DeleteImageDocker', script: '''docker rm -f petclinic-container'''
                sh label: 'DeleteImageDocker', script: '''docker rmi -f petclinic'''
                echo "### Create new image docker..."
                sh label: 'CreateImageDocker', script: '''docker build -t petclinic /home/vagrant/data/spring-petclinic'''
                echo "### Run image docker..."
                sh label: 'RunImageDocker', script: '''docker run -d -p 5000:9090 --name petclinic-container petclinic'''
            }
        }
    }
}
