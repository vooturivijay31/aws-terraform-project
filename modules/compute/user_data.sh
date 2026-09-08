#!/bin/bash

dnf update -y

dnf install -y nginx

cat > /usr/share/nginx/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>AWS Terraform Project</title>
</head>
<body>
    <h1>AWS Terraform Project</h1>
    <h2>Environment: ${environment}</h2>
    <p>Application is running on Amazon Linux and Nginx.</p>
    <p>Infrastructure provisioned using Terraform.</p>
</body>
</html>
EOF

systemctl enable nginx
systemctl start nginx