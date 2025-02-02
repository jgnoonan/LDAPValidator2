#!/bin/bash

# Install the required tools if they're not already installed
which protoc >/dev/null || brew install protobuf
which protoc-gen-swift >/dev/null || brew install swift-protobuf
which protoc-gen-grpc-swift >/dev/null || brew install grpc-swift

# Create the output directory
OUTPUT_DIR="LDAPValidator2/LDAPValidator2/Generated"
mkdir -p "$OUTPUT_DIR"

# Remove any existing generated files
rm -f "$OUTPUT_DIR"/*.swift
rm -f "$OUTPUT_DIR"/*.proto

# Generate the Swift files
protoc ldap_validation.proto \
    --proto_path=. \
    --swift_opt=Visibility=Public \
    --swift_out="$OUTPUT_DIR" \
    --grpc-swift_opt=Visibility=Public \
    --grpc-swift_out="$OUTPUT_DIR"
