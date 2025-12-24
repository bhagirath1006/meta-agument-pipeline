#!/bin/bash
set -e

echo "Starting EC2 instance setup..."
echo "Instance Index: ${instance_index}"
echo "Environment: ${environment}"
echo "Project: ${project_name}"

yum update -y
echo "EC2 instance setup completed!"
