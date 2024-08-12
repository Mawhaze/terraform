FROM hashicorp/terraform:latest

USER root

# Install updates and packages
RUN apk update && \
    apk upgrade && \
    apk add --no-cache aws-cli vim 

# Create the Terraform user
RUN adduser -D -u 1000 sa-terraform

# Create the Terraform directory
RUN mkdir -p /terraform && \
    mkdir /terraform/tmp

    # Copy in required files
COPY ./ /terraform

# Set user and working directory
RUN chown -R sa-terraform:sa-terraform /terraform
USER sa-terraform
WORKDIR /terraform

# Verify the installation
RUN terraform --version
RUN terraform init

# Set the entrypoint
ENTRYPOINT ["/bin/bash"]