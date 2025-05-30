#!/bin/bash

# A clean script to run Hugo using Docker
# Ensure this script has execute permissions: chmod +x run_hugo_docker.sh

# Define the Docker image (latest for automatic updates)
HUGO_IMAGE="hugomods/hugo:latest"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Run Hugo in a Docker container, mapping the current directory
docker run --rm -it \
  -v $(pwd):/src \
  -p 1313:1313 \
  $HUGO_IMAGE \
  server

# Provide feedback to the user
echo "Hugo server is running at: http://localhost:1313"
