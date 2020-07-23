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

        stage('Backup JAR') {
            steps {
                echo "### Backup JAR in directory"
                sh label: '', script: '''mv -i -f /home/vagrant/data/spring-petclinic/jar/petclinic.jar /home/vagrant/data/spring-petclinic/jar/petclinic.jar.bak'''
            }
        }

        stage('CopyPackage') {
            steps {
                echo "### Copy and rename new package..."
                sh label: 'CopyRenamePackage', script: '''mv target/spring-petclinic-*.jar /home/vagrant/data/spring-petclinic/jar/petclinic.jar'''
                echo "### Copy successful, delete old package..."
                sh label: 'DeleteBackup', script: '''rm -i -f /home/vagrant/data/spring-petclinic/jar/petclinic.bak'''
                echo "### Change right to package..."
                sh label: 'AddRight', script: '''sudo chmod 777 /home/vagrant/data/spring-petclinic/jar/petclinic.jar'''
            }
        }

        stage('CreateDockerImage') {
            steps {
                echo "### Delete old image docker..."
                sh label: 'DeleteImageDocker', script: '''docker rmi -f petclinic'''
                echo "### Create new image docker..."
                sh label: 'CreateImageDocker', script: '''docker build -t petclinic /home/vagrant/data/spring-petclinic'''
                echo "### Run image docker..."
                sh label: 'RunImageDocker', script: '''docker run -d -p 5000:9090 petclinic'''
            }
        }
    }
}
