
# Ansible Nginx Setup with Docker

This project provides a Docker-based environment to deploy Nginx on a web server using Ansible for automation. The Docker container is preconfigured to allow SSH access and to be managed via Ansible.

## Table of Contents

- [Dockerfile Overview](#dockerfile-overview)
- [Usage](#usage)
  - [Building the Docker Image](#building-the-docker-image)
  - [Running the Container](#running-the-container)
- [Ansible Playbook](#ansible-playbook)
  - [Inventory Configuration](#inventory-configuration)
  - [Playbook Details](#playbook-details)

## Dockerfile Overview

The Dockerfile sets up an Ubuntu-based container with SSH access and the required tools for managing Nginx with Ansible. It includes the following steps:

1. **Install SSH and sudo:** Updates the container and installs SSH and sudo, allowing remote access and elevated privileges.
2. **Create a user (`nti`)**: A user `nti` is added to the container, with a password `1234` set for SSH login.
3. **Add user to the sudo group:** The `nti` user is added to the sudo group to allow privilege escalation for commands that need root access.
4. **Start SSH service:** The container is configured to start the SSH service and then enter the bash shell when run.

### Dockerfile

```Dockerfile
FROM ubuntuHere’s a comprehensive README for your Dockerfile and Ansible playbook setup. This README explains how to build and use the Docker container, as well as how to configure and deploy Nginx using Ansible.

---


# Install necessary packages
RUN apt update -y && apt install ssh sudo -y

# Add user 'nti' and set password
RUN adduser nti && echo "nti:1234" | chpasswd

# Add 'nti' to sudoers group
RUN usermod -aG sudo nti

# Start SSH and bash shell
ENTRYPOINT service ssh start && bash
```

## Usage

### Building the Docker Image

To build the Docker imHere’s a comprehensive README for your Dockerfile and Ansible playbook setup. This README explains how to build and use the Docker container, as well as how to configure and deploy Nginx using Ansible.

---
age, run the following command in the directory where the `Dockerfile` is located:

```bash
docker build -t ansible-nginx .
```

This will create a Docker image named `ansible-nginx`.

### Running the Container

Once the image is built, you can run a container from it with the following command:

```bash
docker run -d -p 22:22 --name ansible-nginx ansible-nginx
```

This will:
- Run the container in the background (`-d`).
- Map port 22 on the host to port 22 in the container, enabling SSH access.

You can then SSH into Here’s a comprehensive README for your Dockerfile and Ansible playbook setup. This README explains how to build and use the Docker container, as well as how to configure and deploy Nginx using Ansible.

---
the container using:

```bash
ssh nti@<container-ip>  # Default password is '1234'
```

Make sure to replace `<container-ip>` with the actual IP of your running container, or you can use `localhost` if running the container on your local machine.

## Ansible Playbook

This Ansible playbook automates the installation and configuration of Nginx on a web server, as well as deploying a custom `index.html` file.

### Inventory Configuration

The inventory file defines the target hosts for Ansible to manage. In this case, we are using a container with IP `172.17.0.2`, and the `nti` user for SSH access:

```ini
[my_hosts]
172.17.0.2 ansible_user=nti
```

You can update the IP address to match your container or web server.

### Playbook Details

The Ansible playbook (`nginx-setup.yml`) automates the following tasks:

1. **Update apt cache:** Ensures the apt package cache is up to date on the target server.
2. **Install the latest version of Nginx:** Installs Nginx if it isn't already installed.
3. **Copy `index.html`:** Copies a custom `index.html` file from the Ansible controller machine to the web server's Nginx document root (`/var/www/html/`).
4. **Ensure Nginx is running:** Starts the Nginx service and ensures it’s enabled to start on boot using SysVinit.

### Ansible Playbook (`nginx-setup.yml`)

```yaml
---
- name: Configure Nginx on Web Server
  hosts: my_hosts  # Ensure this matches your inventory group
  become: true      # Use privilege escalation to perform tasks like installing packages and managing services
  tasks:

    - name: Update apt cache (Debian/Ubuntu)
      apt:
        update_cache: yes

    - name: Install latest Nginx
      apt:
        name: nginx
        state: latest  # Ensures the latest version is installed

    - name: Install Nginx package if it's not installed
      apt:
        name: nginx
        state: present
        update_cache: yes

    - name: Copy index.html from controller to web server
      ansible.builtin.copy:
        src: /home/mai/ansible/index.html  # Path to the local index.html file on the controller machine
        dest: /var/www/html/index.html
        owner: www-data  # Set the owner to nginx user (adjust if needed)
        group: www-data  # Set the group to nginx user (adjust if needed)
        mode: '0644'

    - name: Ensure Nginx service isHere’s a comprehensive README for your Dockerfile and Ansible playbook setup. This README explains how to build and use the Docker container, as well as how to configure and deploy Nginx using Ansible.

---
 started and enabled using SysVinit
      sysvinit:
        name: nginx  # The name of the service (e.g., nginx)
        state: restarted  # Restart the service
        enabled: yes  # Ensure it starts on boot
```


---

### Additional Notes:

- **Index File Location**: Update the path for the `index.html` file in the playbook (`/home/mai/ansible/index.html`) to reflect where your local `index.html` is stored.
  
- **Accessing the Application**: After running the playbook, you should be able to access Nginx by navigating to the container’s IP address in your browser.

Let me know if you need further customizations!