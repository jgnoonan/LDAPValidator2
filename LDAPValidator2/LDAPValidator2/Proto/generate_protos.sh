#!/bin/bash

# Directory containing .proto files
PROTO_DIR="$PROJECT_DIR/LDAPValidator2/Proto"

# Directory where generated files will be placed
GEN_DIR="$PROJECT_DIR/LDAPValidator2/Generated"

# Create output directory if it doesn't exist
mkdir -p "$GEN_DIR"

# Generate Swift code for each .proto file
for PROTO_FILE in "$PROTO_DIR"/*.proto; do
  # Generate Swift protocol buffers
  protoc --swift_opt=Visibility=Public \
         --swift_out="$GEN_DIR" \
         --grpc-swift_opt=Visibility=Public \
         --grpc-swift_out="$GEN_DIR" \
         --proto_path="$PROTO_DIR" \
         "$PROTO_FILE"
done
