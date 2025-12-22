#!/bin/bash
set -x

# Log all output
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "Starting EC2 instance setup..."
echo "Instance Index: ${instance_index}"
echo "Environment: ${environment}"

# Update system
yum update -y

# Install CloudWatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
rpm -U ./amazon-cloudwatch-agent.rpm

# Install Docker
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group
usermod -a -G docker ec2-user

echo "EC2 instance setup completed!"
