Fargate setup using eksctl on EKS
--------------------------------
- To setup fargate on clsuter install some tools 
 - install eksctl tool
 - install kubectl tool
 - install awscli tool

- Generate AccessKey and secretKey of root account or create IAM user  with specified permissions  to create create fargate EKS cluster 

	    # aws configure

> above command Output 

		vagrant@thej-machine:~$ aws configure
		AWS Access Key ID [None]: AKIA2LW3XXCQXISFFGWM
		AWS Secret Access Key [None]: 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
		Default region name [None]: us-east-1
		Default output format [None]: json
		vagrant@thej-machine:~$ 


- Now create cluster using fargate 
	
	    # eksctl create cluster --name thej-cluster-1 --region us-east-1 --fargate 

> above command will create fargate cluster using eksctl command line tool it will take 15 min to create cluster 

> output

        vagrant@thej-machine:~$ eksctl create cluster --name thej-cluster --region us-east-1 --fargate
        2024-01-30 07:52:07 [ℹ]  eksctl version 0.169.0
        2024-01-30 07:52:07 [ℹ]  using region us-east-1
        2024-01-30 07:52:09 [ℹ]  setting availability zones to [us-east-1f us-east-1a]
        2024-01-30 07:52:09 [ℹ]  subnets for us-east-1f - public:192.168.0.0/19 private:192.168.64.0/19
        2024-01-30 07:52:09 [ℹ]  subnets for us-east-1a - public:192.168.32.0/19 private:192.168.96.0/19
        2024-01-30 07:52:09 [ℹ]  using Kubernetes version 1.27
        2024-01-30 07:52:09 [ℹ]  creating EKS cluster "thej-cluster" in "us-east-1" region with Fargate profile
        2024-01-30 07:52:09 [ℹ]  if you encounter any issues, check CloudFormation console or try 'eksctl utils describe-stacks --region=us-east-1 --cluster=thej-cluster'
        2024-01-30 07:52:09 [ℹ]  Kubernetes API endpoint access will use default of {publicAccess=true, privateAccess=false} for cluster "thej-cluster" in "us-east-1"
        2024-01-30 07:52:09 [ℹ]  CloudWatch logging will not be enabled for cluster "thej-cluster" in "us-east-1"
        2024-01-30 07:52:09 [ℹ]  you can enable it with 'eksctl utils update-cluster-logging --enable-types={SPECIFY-YOUR-LOG-TYPES-HERE (e.g. all)} --region=us-east-1 --cluster=thej-cluster'
        2024-01-30 07:52:09 [ℹ]
        2 sequential tasks: { create cluster control plane "thej-cluster",
            2 sequential sub-tasks: {
                wait for control plane to become ready,
                create fargate profiles,
            }
        }
        2024-01-30 07:52:09 [ℹ]  building cluster stack "eksctl-thej-cluster-cluster"
        2024-01-30 07:52:10 [ℹ]  deploying stack "eksctl-thej-cluster-cluster"
        2024-01-30 07:52:40 [ℹ]  waiting for CloudFormation stack "eksctl-thej-cluster-cluster"
        2024-01-30 07:53:44 [ℹ]  waiting for CloudFormation stack "eksctl-thej-cluster-cluster"
        2024-01-30 07:54:46 [ℹ]  waiting for CloudFormation stack "eksctl-thej-cluster-cluster"
        2024-01-30 07:55:54 [ℹ]  waiting for CloudFormation stack "eksctl-thej-cluster-cluster"
        2024-01-30 07:56:56 [ℹ]  waiting for CloudFormation stack "eksctl-thej-cluster-cluster"
        2024-01-30 07:58:31 [ℹ]  waiting for CloudFormation stack "eksctl-thej-cluster-cluster"
        2024-01-30 07:59:32 [ℹ]  waiting for CloudFormation stack "eksctl-thej-cluster-cluster"
        2024-01-30 08:00:49 [ℹ]  waiting for CloudFormation stack "eksctl-thej-cluster-cluster"
        2024-01-30 08:03:07 [ℹ]  creating Fargate profile "fp-default" on EKS cluster "thej-cluster"
        2024-01-30 08:05:19 [ℹ]  created Fargate profile "fp-default" on EKS cluster "thej-cluster"
        2024-01-30 08:05:50 [ℹ]  "coredns" is now schedulable onto Fargate
        2024-01-30 08:06:57 [ℹ]  "coredns" is now scheduled onto Fargate
        2024-01-30 08:06:57 [ℹ]  "coredns" pods are now scheduled onto Fargate
        2024-01-30 08:06:57 [ℹ]  waiting for the control plane to become ready
        2024-01-30 08:06:58 [✔]  saved kubeconfig as "/home/vagrant/.kube/config"
        2024-01-30 08:06:58 [ℹ]  no tasks
        2024-01-30 08:06:58 [✔]  all EKS cluster resources for "thej-cluster" have been created
        2024-01-30 08:06:59 [✖]  getting Kubernetes version on EKS cluster: error running `kubectl version`: exit status 1 (check 'kubectl version')
        2024-01-30 08:06:59 [ℹ]  cluster should be functional despite missing (or misconfigured) client binaries
        2024-01-30 08:06:59 [✔]  EKS cluster "thej-cluster" in "us-east-1" region is ready
        vagrant@thej-machine:~$



- After complete of cluster now update config file of cluster into Local machine To connect and run kubectl commands 
	
	    # aws eks update-kubeconfig --name thej-cluster-1 --region us-east-1

- above command will download or update config file in the local machine to connect remote fargate cluster config fil location in the system .kube/config
- above command make sure only excute when connecting with new machine only 

- To check nodes of cluster 

> Output

    	[ec2-user@ip-172-31-89-76 ~]$ kubectl get nodes
    	NAME                                      STATUS   ROLES    AGE   VERSION
    	fargate-ip-192-168-123-226.ec2.internal   Ready    <none>   44m   v1.27.7-eks-4f4795d
    	fargate-ip-192-168-87-72.ec2.internal     Ready    <none>   44m   v1.27.7-eks-4f4795d
    	[ec2-user@ip-172-31-89-76 ~]$ 


====================Fargate Cluter creation complete===================================
