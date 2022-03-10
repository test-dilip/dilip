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
echo "provide avaiability zone"
read b
echo "enter name of the cluster"
read c
aws s3 mb s3://$c.dev.$a.com
echo "export PATH=$PATH:/usr/local/bin:/usr/local/sbin" >> /etc/profile
source /etc/profile
echo "export KOPS_STATE_STORE=s3://$c.dev.$a.com" >> /etc/profile
source /etc/profile
#generate ssh keys
ssh-keygen
#install docker
sudo yum install docker -y

#create cluster
kops create cluster $c.dev.$a.com --zones=$b --node-size=t2.micro --master-size=t2.micro --dns-zone=$a.com --dns private
kops update cluster --name $c.dev.$a.com --yes
