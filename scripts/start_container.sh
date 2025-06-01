#!/bin/bash
# Get image tag from SSM Parameter Store
IMAGE_TAG=$(aws ssm get-parameter --name "/myapp/docker-image-tag" --query "Parameter.Value" --output text --region ap-south-1) # REPLACE YOUR_REGION

# Build ECR image URI
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REPO_URL="${AWS_ACCOUNT_ID}.dkr.ecr.ap-south-1.amazonaws.com/my-java-app" # REPLACE YOUR_REGION and repo name

# Login to ECR
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin ${ECR_REPO_URL} # REPLACE YOUR_REGION

# Stop and remove existing container if running
docker stop gs-rest-service-container || true
docker rm gs-rest-service-container || true

# Pull the new image and run the container
docker pull ${ECR_REPO_URL}:${IMAGE_TAG}
docker run -d --name gs-rest-service-container -p 80:8080 ${ECR_REPO_URL}:${IMAGE_TAG} # Map host port 80 to container port 8080
