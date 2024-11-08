This repository demonstrates how to utilize GitHub Actions workflows with Terraform and Ansible to deploy and configure infrastructure on Azure.

# Architecture
https://github.com/yassersicher/Hylastik_project/blob/830ce1da0724f52c6387eb8de0036ff99faf7c31/2.png
# Documentation
## Provisioning the infrastructure  
The VM runs an Ubuntu Server and is connected to a Network Interface (NIC), which is associated with the internal subnet. The NSG has two inbound rules allowing traffic on ports 8088 (for Keycloak) and 8001 (for NGINX). Additionally, the configuration includes a backend setup for state management, storing the Terraform state file in an Azure Storage Account.
## Configuration of the infrastructure
### Installation and configuration of Docker
The Ansible playbook automates the process of setting up Docker on remote systems. It begins by ensuring that the necessary system packages and repositories are configured, followed by adding Docker's official software sources. The playbook then installs Docker and ensures that the Docker service is not only running but also set to start automatically when the system boots
### Creation of containers 
This Docker Compose file configures a three-container setup with Keycloak, PostgreSQL, and NGINX:
Keycloak: Provides identity management, connects to PostgreSQL for storage, and is set up with necessary database and admin credentials.
PostgreSQL: Stores Keycloak data, using a dedicated volume for persistence.
NGINX:The nginx.conf file is bind-mounted from the host system to the container, allowing for custom NGINX configurations. 
### Github actions 
GitHub Actions manages the full lifecycle—from creating to configuring  and launching the services—directly from the repository, automating deployment and simplifying maintenance across environments..
