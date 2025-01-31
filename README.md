# LDAP Validator iOS App

An iOS application that validates LDAP credentials via gRPC communication with a registration service. The app supports Microsoft Entra ID (formerly Azure AD) authentication.

## Features

- Validate LDAP credentials against Microsoft Entra ID
- Secure gRPC communication with backend service
- SwiftUI-based user interface
- Async/await support for modern Swift concurrency

## Prerequisites

- Xcode 15.0 or later
- iOS 15.0 or later
- Swift 5.9 or later
- Protocol Buffers compiler (`protoc`)
- Swift gRPC plugin

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/jgnoonan/LDAPValidator2.git
   cd LDAPValidator2
   ```

2. Install the required tools:
   ```bash
   brew install protobuf swift-protobuf grpc-swift
   ```

3. Open the project in Xcode:
   ```bash
   open LDAPValidator2/LDAPValidator2.xcodeproj
   ```

## Project Structure

- `/LDAPValidator2` - Main Xcode project directory
  - `/GRPC` - gRPC client implementations
    - `/Models` - Shared data models
  - `/Generated` - Generated Swift files from proto definitions
  - `/Proto` - Protocol Buffer definitions

## Development

### Regenerating Proto Files

If you modify the proto definitions, regenerate the Swift files using:

```bash
cd LDAPValidator2/Proto
./generate_protos.sh
```

### Dependencies

- [SwiftProtobuf](https://github.com/apple/swift-protobuf)
- [gRPC Swift](https://github.com/grpc/grpc-swift)
- [Swift Log](https://github.com/apple/swift-log)

## Configuration

The gRPC client is configured to connect to `localhost:50051` by default. Update the host and port in `EntraGRPCClient.swift` and `LDAPGRPCClient.swift` to match your backend service configuration.

## Testing

The project includes both unit tests and UI tests. Run them in Xcode using:
- Product > Test, or
- ⌘U

## License

[Your chosen license]

## Contributing

[Your contribution guidelines]
