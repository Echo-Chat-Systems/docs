# Setup

Details project installation and setup instructions.

## Prerequisites

- Basic Unix command line knowledge (Ubuntu is used throughout the demo)
- Console access to a dedicated linux box (or a VM)
- A domain name pointing to the IP address of the linux box. Replace `dafox.au` with your domain throughout the example.
- A valid SSL certificate for the domain name (cloudflare is used throughout the demo)

## Step 1: Install Requirements

This project uses Python3.12 as the python version. It will not run on anything lower.

Python3.12 is not available in the default repositories. You will need to add the deadsnakes repository:

```bash
sudo add-apt-repository ppa:deadsnakes/ppa;
sudo apt update;
```

Now that the repository is added, all packages can be installed in one go:

```bash
sudo apt install python3.12 python3.12-pip python3.12-venv nginx screen git authbind gunicorn -y;
```

## Step 2: Clone the Repository

Clone the repository to your local machine:

```bash
git clone https://github.com/Yuki-42/echo-api.git; 
```

## Step 3: Prepare the virtual environment

Create a virtual environment and install the requirements:

```bash
cd echo-api/;
python3.12 -m venv venv;

source venv/bin/activate;
pip3 install -r requirements.txt;
```

## Step 4: Configure Nginx

Remove the default configuration:

```bash
sudo rm /etc/nginx/sites-enabled/default;
```

Create a new configuration file:

```bash
sudo nano /etc/nginx/sites-available/echo-api;
```

Add the following configuration, remembering to replace `dafox.au` with your domain and `USERNAME` with your username:

```nginx
# Eco API
server {
    listen 443 deferred;
    server_name echo-api.dafox.au;

    ssl_certificate     /etc/ssl/dafox.au.crt;
    ssl_certificate_key /etc/ssl/dafox.au.key;
    ssl_protocols       TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
    ssl_ciphers         HIGH:!aNULL:!MD5;

    client_max_body_size 4G;

    # Path for static files
    location /static/ {
        alias /var/www/html/echo-api/;
    }

    location / {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $http_host;
        
        proxy_redirect off;
        proxy_pass http://127.0.0.1:8000;
    }
}
```

Edit the master nginx configuration file:

```nginx
worker_processes auto;

user nobody nogroup;
# 'user nobody nobody;' for systems with 'nobody' as a group instead
error_log  /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024; # increase if you have lots of clients
    accept_mutex on; # set to 'on' if nginx worker_processes > 1
    # 'use epoll;' to enable for Linux 2.6+
    # 'use kqueue;' to enable for FreeBSD, OSX
}

http {
    include mime.types;
    include /etc/nginx/sites-enabled/*;
    include /etc/nginx/access.conf;
    # fallback in case we can't determine a type
    default_type application/octet-stream;
    access_log /var/log/nginx/access.log combined;
    sendfile on;
    
    client_max_body_size 4G;
}
```

Enable the configuration:

```bash
sudo ln -s /etc/nginx/sites-available/echo-api /etc/nginx/sites-enabled/echo-api;
```

Restart Nginx:

```bash
sudo systemctl restart nginx;
```

## Step 5: Link static files

Create a symbolic link to the static files:

```bash
ln -s /home/USERNAME/echo-api/static/ /var/www/html/echo-api;
```

## Step 6: Run the server

Start the server:

```bash
cd echo-api/;
source venv/bin/activate;
sh start.sh;
```
