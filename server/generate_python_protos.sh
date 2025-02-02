#!/bin/bash

# Create Python proto output directory
mkdir -p .

# Generate Python files from proto
python3 -m grpc_tools.protoc \
    -I.. \
    --python_out=. \
    --grpc_python_out=. \
    ../ldap_validation.proto
