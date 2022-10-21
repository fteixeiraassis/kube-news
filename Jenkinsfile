pipeline  {
    agent any

    stages {
        stage ("Build Docker Image") {
            steps {
                dockerapp = docker.build("fteixeiraassis/kube-news:${env.BUILD_ID}", '-f ./src/Dockerfile ./src')
            }
        }
    }
}
