## data-stack-ui-swagger

The `data-stack-ui-swagger` component generates Swagger documentation for data services and transaction APIs. It is built on top of [Swagger UI v5.0.0](https://github.com/swagger-api/swagger-ui/releases/tag/v5.0.0) and supports [OAS 3.0.0](https://github.com/OAI/OpenAPI-Specification/blob/main/versions/3.0.0.md).

### Setting up a Development Environment 
#### Prerequisites
- Git
- Node.js (v14.21.3)
- Nginx
#### Steps
To set up the development environment, follow these steps:
1) Build `ds-ui-author` and `ds-ui-appcenter` using `ng build`.
2) Ensure all necessary backend components are running locally
3) Use the following Nginx configuration to serve `ds-ui-swagger`:
  ```nginx
user nginx;
worker_processes auto;

error_log /var/log/nginx/error.log;

events {
   worker_connections 1024;
}

http {
    include mime.types;

    default_type application/octet-stream;

    server {
        listen 80 default_server;
        listen [::]:80 default_server;

        client_max_body_size 100M;

        server_name *.com localhost;

        root /var/www/html;

        index index.html;

        # Redirect the root URL to /author
        location / {
            return 301 /author;
        }

        # Serve build files of ds-ui-author from the /var/www/author directory
        location /author {
            alias /var/www/author;
        }

        # Serve build files of ds-ui-appcenter from the /var/www/appcenter directory
        location /appcenter {
            alias /var/www/appcenter;
        }

        # Serve ds-ui-swagger 
        location /doc {
            alias /var/www/ds-ui-swagger;
        }

        # Proxy requests to the /api path to http://localhost:9080
        # Handled by locally running backend components
        location /api {
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_pass http://localhost:9080;
        }

        location /socket.io {
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "Upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_pass http://localhost:9080;
        }
    }
}

  ```
