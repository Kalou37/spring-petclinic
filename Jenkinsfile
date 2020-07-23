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
                echo "### Start to build the package..."
                sh "mvn clean install"
            }

            post {
                success {
                    echo "### Build successful !"
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
                sh label: 'DeleteImageDocker', script: '''docker rmi -f petclinic-image'''
                echo "### Create new image docker..."
                sh label: 'CreateImageDocker', script: '''docker build -t petclinic /home/vagrant/data/spring-petclinic'''
                echo "### Run image docker..."
                sh label: 'RunImageDocker', script: '''docker run -d -p 5000:9090 --name petclinic-container petclinic'''
            }
        }
    }
}
