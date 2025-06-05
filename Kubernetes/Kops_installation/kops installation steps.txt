1.create kopsServer with bootstrapscript 
Bootstrapscript
--------------------
#!/bin/bash
sudo hostnamectl set-hostname KopsServer
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl 
-------------------------------------------
2.create IAM administrator role and link with Kopsserver
3.connect to kopsserver create s3 bucket
$ aws s3 mb s3://thejstore123.in.k8s --region ap-southeast-1
4.create route53 with name thejdomain123.in
5.provide environment variable in .bashrc
$vim .bashrc
====================
export KOPS_CLUSTER_NAME=thejdomain123.in
export KOPS_STATE_STORE=s3://thejstore123.in.k8s
===================
$ source .bashrc
6.generate ssh keys
$ genrate ssh-keygen
7.create kubernetes cluster 
$ kops create cluster \
--state=${KOPS_STATE_STORE} \
--node-count=2 \
--master-size=t3.large \
--node-size=t3.large \
--zones=ap-southeast-1a \
--name=${KOPS_CLUSTER_NAME} \
--dns private \
--master-count 1
8.create kubernetes cluster 
$ kops update cluster --yes --admin
9.to establish cluster it takes some time upto 10 to 15 min upto then excute command
$kops validate cluster 
10.to display cluster nodes
$kubectl get nodes
11.to delete cluster
$kops delete cluster  --yes