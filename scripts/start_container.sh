#!/bin/bash

# Stop and remove any existing container instance
docker stop my-java-app-container || true
docker rm my-java-app-container || true

# Define your ECR details and get image tag from SSM
AWS_REGION="ap-south-1" # <--- REPLACE WITH YOUR AWS REGION (e.g., ap-south-1)
AWS_ACCOUNT_ID="026090550864" # <--- REPLACE WITH YOUR AWS ACCOUNT ID
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
ECR_REPOSITORY="my-java-app" # Your ECR repository name

# Get the latest image tag from SSM Parameter Store (set by GitHub Actions)
# Ensure this parameter is correctly updated by your GitHub Actions workflow
IMAGE_TAG=$(aws ssm get-parameter --name "/my-java-app/image-tag" --query "Parameter.Value" --output text --region "${AWS_REGION}")

# Login to ECR
aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin "${ECR_REGISTRY}"

# Pull the latest Docker image
docker pull "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"

# Run the new container, mapping port 80 (EC2) to 8080 (container)
docker run -d -p 80:8080 --name my-java-app-container "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
