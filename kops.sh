#! /bin/bash
#install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl

#install kops
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -LO  https://github.com/kubernetes/kops/releases/download/1.15.0/kops-linux-amd64)
chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops
echo "provide domain name ex: vamshi"
read a
aws s3 mb s3://clusters.dev.$a.com
echo "export PATH=$PATH:/usr/local/kops" >> /etc/profile
echo "export KOPS_STATE_STORE=s3://clusters.dev.$a.com" >> /etc/profile
source /etc/profile
#generate ssh keys
ssh-keygen
sudo cp -pr /usr/local/bin/kops /usr/local/sbin
sudo cp -pr /usr/local/bin/kubectl /usr/local/sbin
#install docker
sudo yum install docker -y

#create cluster
echo "provide avaiability zone"
read b
kops create cluster clusters.dev.$a.com --zones=$b --node-size=t2.micro --master-size=t2.micro --dns-zone=$a.com --dns private
kops update cluster --name clusters.dev.$a.com --yes
