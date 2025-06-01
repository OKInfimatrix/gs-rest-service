#!/bin/bash
docker stop gs-rest-service-container || true
docker rm gs-rest-service-container || true
