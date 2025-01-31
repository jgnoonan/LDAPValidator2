import Foundation
import GRPC
import Logging
import NIO
import SwiftProtobuf
import LDAPValidator2 // Assuming LDAPValidationResult is defined in this module

public class EntraGRPCClient {
    private let logger: Logger
    private let channel: GRPCChannel
    
    public init(logger: Logger) {
        self.logger = logger
        
        // Configure channel options
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        let channel = ClientConnection.insecure(group: group)
            .connect(host: "localhost", port: 50051)
        self.channel = channel
    }
    
    deinit {
        try? channel.close().wait()
    }
    
    public func validateCredentials(userId: String, password: String) async throws -> LDAPValidationResult {
        let client = Org_Signal_Registration_Ldap_Rpc_LdapValidationServiceAsyncClient(channel: channel)
        
        var request = Org_Signal_Registration_Ldap_Rpc_ValidateCredentialsRequest()
        request.userID = userId
        request.password = password
        
        do {
            let response = try await client.validateCredentials(request)
            switch response.result {
            case .phoneNumber(let number):
                return LDAPValidationResult(isValid: true, phoneNumber: number)
            case .error(let error):
                logger.error("Validation error: \(error.message)")
                return LDAPValidationResult(isValid: false, phoneNumber: nil)
            case .none:
                logger.error("No result received")
                return LDAPValidationResult(isValid: false, phoneNumber: nil)
            }
        } catch {
            logger.error("Entra ID validation failed: \(error)")
            throw error
        }
    }
}
