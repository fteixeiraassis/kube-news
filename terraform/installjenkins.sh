#/bin/bash
#script para instalação do jenkins
#necessario instalação do java
#instalação docker e kubectl para trabalhar com aplicações
#install java
sudo apt update -y
sudo apt install openjdk-17-jdk -y

#---------------------------------------------------------------------------
#install jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y
systemctl enable jenkins

#---------------------------------------------------------------------------
# install docker
sudo curl fsSL https://get.docker.com | sh
sudo usermod -aG docker jenkins
systemctl restart jenkins

#---------------------------------------------------------------------------
#install kubectl
#Update the apt package index and install packages needed to use the Kubernetes apt repository:
sudo apt-get update
sudo apt-get install -y ca-certificates curl

#If you use Debian 9 (stretch) or earlier you would also need to install apt-transport-https:
sudo apt-get install -y apt-transport-https

#Download the Google Cloud public signing key:
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

#Add the Kubernetes apt repository:
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

#Update apt package index with the new repository and install kubectl:
sudo apt-get update -y
sudo apt-get install -y kubectl

#---------------------------------------------------------------------------
#para entrar no jenkins acesse o ip_externo:8080
#Entre no terminal do server do jenkins e digite: cat /var/lib/jenkins/secrets/initialAdminPassword
#o resultado sera a chave para acessar o jenkins