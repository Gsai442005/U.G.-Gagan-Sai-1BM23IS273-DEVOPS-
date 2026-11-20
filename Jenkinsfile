pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'python3 -m pip install -r requirements.txt'
            }
        }

        stage('Test') {
            steps {
                sh 'python3 -m unittest discover -s .'
            }
        }

        stage('Deploy') {
            steps {
                sh 'mkdir -p deployment'
                sh 'cp app.py requirements.txt deployment/'
            }
        }
    }
}
