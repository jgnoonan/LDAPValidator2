import Foundation
import GRPC
import NIO
import Logging

class LDAPGRPCClient {
    private let channel: GRPCChannel
    private let client: LdapValidationServiceAsyncClient
    private let logger = Logger(label: "com.valuelabs.ldapvalidator")
    
    init() {
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        
        do {
            channel = try GRPCChannelPool.with(
                target: .host("localhost", port: 50051),
                transportSecurity: .plaintext,
                eventLoopGroup: group
            )
            client = LdapValidationServiceAsyncClient(channel: channel)
        } catch {
            fatalError("Failed to create gRPC channel: \(error)")
        }
    }
    
    deinit {
        try? channel.close().wait()
    }
    
    func validateCredentials(userId: String, password: String) async throws -> ValidateCredentialsResponse {
        var request = ValidateCredentialsRequest()
        request.userID = userId
        request.password = password
        
        do {
            let response = try await client.validateCredentials(request)
            logger.info("LDAP validation successful")
            return response
        } catch {
            logger.error("LDAP validation failed: \(error)")
            throw error
        }
    }
}
