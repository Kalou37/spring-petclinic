pipeline {
    agent any

    stages {
        stage("Checkout SCM") {
            steps {
                checkout SCM
            }

            post {
                failure {
                    echo "### Error checking SCM..."
                    error('Aborting the pipeline.')
                }
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
                sh label: '', script: '''mv -i -f /home/vagrant/petclinic/*.jar /home/vagrant/petclinic/petclinic.jar.bak'''
            }
        }

        stage('CopyPackage') {
            steps {
                echo "### Copy and rename new package..."
                sh label: '', script: '''mv target/spring-petclinic-*.jar /home/vagrant/petclinic/petclinic.jar'''
                echo "### Copy successful, delete old package..."
                sh label: '', script: '''rm -i -f /home/vagrant/petclinic/*.bak'''
                echo "### Change right to package..."
                sh label: '', script: '''sudo chmod 777 /home/vagrant/petclinic/petclinic.jar'''
            }
        }

        stage('RestartService') {
            steps {
                echo "### Restart PetClinin service..."
                sh label: '', script: '''sudo service petclinic restart'''
            }
        }
    }
}
