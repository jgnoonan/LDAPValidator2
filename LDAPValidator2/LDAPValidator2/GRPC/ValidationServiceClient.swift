import Foundation
import GRPC
import NIO
import Logging

class ValidationServiceClient {
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
    
    func validateCredentials(userId: String, password: String, isEntraId: Bool) async throws -> (isValid: Bool, phoneNumber: String?, errorMessage: String?) {
        var request = ValidateCredentialsRequest()
        request.userID = userId
        request.password = password
        
        logger.info("\(isEntraId ? "Entra ID" : "LDAP") validation request for user: \(userId)")
        
        do {
            logger.info("Sending validation request to server...")
            let response = try await client.validateCredentials(request)
            logger.info("Received response from server")
            
            switch response.result {
            case .phoneNumber(let number):
                logger.info("\(isEntraId ? "Entra ID" : "LDAP") validation successful. Phone number retrieved: \(number)")
                return (true, number, nil)
            case .error(let error):
                logger.error("\(isEntraId ? "Entra ID" : "LDAP") validation failed with error: \(error.message)")
                return (false, nil, error.message)
            case .none:
                logger.error("\(isEntraId ? "Entra ID" : "LDAP") validation failed: Server returned no result")
                return (false, nil, "Server returned no result")
            }
        } catch {
            logger.error("\(isEntraId ? "Entra ID" : "LDAP") validation failed with error: \(error.localizedDescription)")
            throw error
        }
    }
}
