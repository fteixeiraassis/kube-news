pipeline  {
    agent any

    stages {
        stage ("Build Docker Image") {
            steps {
                dockerapp = docker.Build("fteixeiraassis\kube-news:latest", '-f ./src/Dockerfile ./src')
            }
        }
    }
}
