#!/bin/bash
docker stop my-java-app-container || true
docker rm my-java-app-container || true
docker image prune -f
