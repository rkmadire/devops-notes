# How to Integrate Terraform with Jenkins

### Step 1: Setup Terraform on Jenkins Machine
Install Terraform on the Jenkins machine. You can download Terraform from the official [Terraform website](https://www.terraform.io/downloads).

### Step 2: Install Jenkins Plugins
Install the **Terraform plugin** from the Jenkins Plugin Manager.

---

### Jenkinsfile

```groovy
pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'ap-south-1'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/CodeSagarOfficial/jenkins-scripts.git'
            }
        }
        stage('Terraform init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Plan') {
            steps {
                sh 'terraform plan -out tfplan'
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Apply / Destroy') {
            steps {
                script {
                    if (params.action == 'apply') {
                        if (!params.autoApprove) {
                            def plan = readFile 'tfplan.txt'
                            input message: "Do you want to apply the plan?",
                            parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                        }

                        sh 'terraform ${action} -input=false tfplan'
                    } else if (params.action == 'destroy') {
                        sh 'terraform ${action} --auto-approve'
                    } else {
                        error "Invalid action selected. Please choose either 'apply' or 'destroy'."
                    }
                }
            }
        }

    }
}
```

---

### main.tf

```hcl
resource "aws_instance" "public_instance" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = var.name_tag,
  }
}
```

---

### output.tf

```hcl
output "public_ip" {
  value       = aws_instance.public_instance.public_ip
  description = "Public IP Address of EC2 instance"
}

output "instance_id" {
  value       = aws_instance.public_instance.id
  description = "Instance ID"
}
```

---

### provider.tf

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}
```

---

### variable.tf

```hcl
variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  default     = ""
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "ami" {
  type        = string
  description = "Ubuntu

```hcl
  AMI ID"
  default     = "ami-0f5ee92e2d63afc18"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
  default     = "t2.micro"
}

variable "name_tag" {
  type        = string
  description = "Name of the EC2 instance"
  default     = "My EC2 Instance"
}
```

---

This setup demonstrates how to integrate Terraform with Jenkins using a Jenkins pipeline, which checks out code from a repository, initializes Terraform, creates a plan, and either applies or destroys the infrastructure based on user input.

Make sure to set up the proper AWS credentials in Jenkins (through `credentials`), and ensure Terraform is correctly installed on the Jenkins server for this integration to work smoothly.