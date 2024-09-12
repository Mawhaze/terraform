// Set up Terraform Jenkins folders
folder('terraform/deployments') {
  description('Terraform Jenkins jobs to deploy infrastructure')
}

folder('terraform/utility') {
  description('Terraform Jenkins utility jobs')
}
// Define the Terraform build jobs within the terraform/deployments/proxmox folder
// Keep this alphabetical for easier maintenance
pipelineJob('terraform/deployments/proxmox_inventory') {
  logRotator {
    numToKeep(10) //Only keep the last 10
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
                script {
                    docker.image('mawhaze/terraform:latest').inside('--entrypoint="" -e AWS_DEFAULT_REGION=us-west-2 \
                    -e AWS_ACCESS_KEY_ID=\$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=\$AWS_SECRET_ACCESS_KEY \
                    -e TF_VAR_proxmox_username=\$PROXMOX_USERNAME -e TF_VAR_proxmox_password=\$PROXMOX_PASSWORD') {
                        sh 'ls -la /terraform'
                        sh 'mkdir -p /terraform/tf_output'
                        sh 'cd /terraform/proxmox && terraform init && terraform plan -out=/terraform/tf_output/tfplan'
                        sh 'ls -la /terraform/tf_output/tfplan'
                        sh 'cp /terraform/tf_output/tfplan \$WORKSPACE/'
                        stash includes: 'tfplan', name: 'terraform-plan'
                    }
                }
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
                script {
                    docker.image('mawhaze/terraform:latest').inside('--entrypoint="" -e AWS_DEFAULT_REGION=us-west-2 \
                    -e AWS_ACCESS_KEY_ID=\$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=\$AWS_SECRET_ACCESS_KEY \
                    -e TF_VAR_proxmox_username=\$PROXMOX_USERNAME -e TF_VAR_proxmox_password=\$PROXMOX_PASSWORD') {
                        sh 'mkdir -p /terraform/tf_output'
                        unstash 'terraform-plan'
                        sh 'mv tfplan /terraform/tf_output/tfplan'
                        sh 'ls -la /terraform/tf_output/'
                        sh 'cd /terraform/proxmox && terraform init && terraform apply -auto-approve /terraform/tf_output/tfplan'
                    }
                }
            }
        }
    }
    stage('Trigger Ansible Bootstrap Playbook') {
        steps {
            script {
                build job: '/ansible/playbooks/ubuntu_bootstrap', wait: true
          }
        }
    }
  }
}
      """)
    }
  }
}

// Utility jobs for Terraform
pipelineJob('terraform/utility/release_stale_lock') {
  logRotator {
    numToKeep(10) //Only keep the last 10
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
    stage('Release a stale lock file') {
        steps {
            withCredentials([
                usernamePassword(credentialsId: 'sa_terraform_proxmox_creds', usernameVariable: 'PROXMOX_USERNAME', passwordVariable: 'PROXMOX_PASSWORD'),
                string(credentialsId: 'sa_terraform_aws_access_key_id', variable: 'AWS_ACCESS_KEY_ID'),
                string(credentialsId: 'sa_terraform_aws_secret_access_key', variable: 'AWS_SECRET_ACCESS_KEY')
            ]) {
              script {
                docker.image('mawhaze/terraform:latest').inside('--entrypoint="" -e AWS_DEFAULT_REGION=us-west-2 \
                -e AWS_ACCESS_KEY_ID=\$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=\$AWS_SECRET_ACCESS_KEY \
                -e TF_VAR_proxmox_username=\$PROXMOX_USERNAME -e TF_VAR_proxmox_password=\$PROXMOX_PASSWORD') {
                  sh 'cd /terraform/proxmox && terraform init && terraform force-unlock -force $(cat mawhaze-terraform-state/proxmox/terraform.tfstate)'
                }
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