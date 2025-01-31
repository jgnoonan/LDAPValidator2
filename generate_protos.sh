#!/bin/bash

# Install the required tools if they're not already installed
which protoc >/dev/null || brew install protobuf
which protoc-gen-swift >/dev/null || brew install swift-protobuf
which protoc-gen-grpc-swift >/dev/null || brew install grpc-swift

# Create the output directory
mkdir -p LDAPValidator2/LDAPValidator2/Proto

# Generate the Swift files
protoc ldap_validation.proto \
    --proto_path=. \
    --swift_opt=Visibility=Public \
    --swift_out=LDAPValidator2/LDAPValidator2/Proto \
    --grpc-swift_opt=Visibility=Public \
    --grpc-swift_out=LDAPValidator2/LDAPValidator2/Proto
