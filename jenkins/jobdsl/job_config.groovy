// Set up Terraform Jenkins folders
folder('terraform/deployments') {
  description('Terraform Jenkins jobs to deploy infrastructure')
}

folder('terraform/deployments/proxmox') {
  description('Terraform Jenkins jobs to deploy infrastructure to Proxmox')
}

// Define the Terraform build jobs within the terraform/deployments/proxmox folder
// Keep this alphabetical for easier maintenance
pipelineJob('terraform/deployments/proxmox/proxmox_ubuntu_2404_template') {
  logRotator {
    numToKeep(10) //Only keep the last 10
  }
  parameters {
    choiceParam('TF_VAR_host_node', ['node01', 'storage'], 'Select the destination node')
    choiceParam('TF_VAR_node_size', ['small', 'large'], 'Select the size of the VM')
    stringParam('TF_VAR_vm_name', '', 'Enter the name of the VM')
  }
  definition {
    cps {
      // Inline Groovy script for pipeline definition
      script("""
pipeline {
  agent any
  stages {
    stage('Sign into DockerHub and Pull Docker Image') {
        steps {
            script {
                docker.withRegistry('https://index.docker.io/v1/', 'dockerhub_credentials') {
                    // Pull the Docker image from DockerHub before running it
                    sh "docker pull mawhaze/terraform:latest"
                }
            }
        }
    }
    stage('Run Terraform Init and Plan') {
        steps {
            withCredentials([
                usernamePassword(credentialsId: 'sa_terraform_proxmox_creds', usernameVariable: 'PROXMOX_USERNAME', passwordVariable: 'PROXMOX_PASSWORD'),
                string(credentialsId: 'sa_terraform_aws_access_key_id', variable: 'AWS_ACCESS_KEY_ID'),
                string(credentialsId: 'sa_terraform_aws_secret_access_key', variable: 'AWS_SECRET_ACCESS_KEY')
            ]) {
                sh(
                    'docker run --rm -e AWS_DEFAULT_REGION=us-west-2 \
                    -e AWS_ACCESS_KEY_ID=\$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=\$AWS_SECRET_ACCESS_KEY \
                    -e PROXMOX_USERNAME=\$PROXMOX_USERNAME -e PROXMOX_PASSWORD=\$PROXMOX_PASSWORD \
                    -e TF_VAR_host_node=\$TF_VAR_host_node \
                    -e TF_VAR_node_size=\$TF_VAR_node_size -e TF_VAR_vm_name=\$TF_VAR_vm_name \
                    --entrypoint sh mawhaze/terraform:latest \
                    -c "terraform -chdir=./proxmox init && terraform -chdir=./proxmox plan -out=tfplan"'
                )
            }
        }
    }
    stage('Run Terraform apply') {
        steps {
            withCredentials([
                usernamePassword(credentialsId: 'sa_terraform_proxmox_creds', usernameVariable: 'PROXMOX_USERNAME', passwordVariable: 'PROXMOX_PASSWORD'),
                string(credentialsId: 'sa_terraform_aws_access_key_id', variable: 'AWS_ACCESS_KEY_ID'),
                string(credentialsId: 'sa_terraform_aws_secret_access_key', variable: 'AWS_SECRET_ACCESS_KEY')
            ]) {
                sh(
                    'docker run --rm -e AWS_DEFAULT_REGION=us-west-2 \
                    -e AWS_ACCESS_KEY_ID=\$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=\$AWS_SECRET_ACCESS_KEY \
                    -e PROXMOX_USERNAME=\$PROXMOX_USERNAME -e PROXMOX_PASSWORD=\$PROXMOX_PASSWORD \
                    -e TF_VAR_host_node=\$TF_VAR_host_node \
                    -e TF_VAR_node_size=\$TF_VAR_node_size -e TF_VAR_vm_name=\$TF_VAR_vm_name \
                    --entrypoint sh mawhaze/terraform:latest \
                    -c "terraform -chdir=./proxmox apply tfplan"'
                )
            }
        }
    }
  }
}
      """)
    }
  }
}

// Docker build job for Terraform
pipelineJob('docker/build/terraform') {
  logRotator {
    numToKeep(10) //Only keep the last 10
  }
  definition {
    cpsScm {
      scm {
        git {
          remote {
            url('https://github.com/mawhaze/terraform.git')
            credentials('github_access_token')
          }
          branches('*/main')
          scriptPath('Jenkinsfile')
        }
      }
    }
  }
  triggers {
    scm('H/15 * * * *') // Poll SCM every 15 minutes.
  }
}