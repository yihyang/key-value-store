#!/bin/bash

# Get app version
dir=$(dirname "$0")
version=$(cat ${dir}/../image_version.txt)

# Tracking version
OPS_DIR="/opt/carro-ops"
export KEY_VALUE_STORE_VERSION=${version}

# Compose up
cd $OPS_DIR
docker-compose -up -d kvs
