#!/bin/bash

docker stop my-java-app-container || true
docker rm my-java-app-container || true

# Define your ECR details and get image tag from SSM
AWS_REGION="ap-south-1"
AWS_ACCOUNT_ID="026090550864"
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
ECR_REPOSITORY="my-java-app"

# Get the latest image tag from SSM Parameter Store (set by GitHub Actions)
IMAGE_TAG=$(aws ssm get-parameter --name "/my-java-app/image-tag" --query "Parameter.Value" --output text --region "${AWS_REGION}")

aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin "${ECR_REGISTRY}"

docker pull "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"

docker run -d -p 80:8080 --name my-java-app-container "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
