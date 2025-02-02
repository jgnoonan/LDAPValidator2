import Foundation
import GRPC
import NIO

struct ValidationResult {
    let isValid: Bool
    let phoneNumber: String?
    let errorMessage: String?
}

class ValidationServiceClient {
    private let client: Org_Signal_Registration_Ldap_Rpc_LdapValidationServiceAsyncClient
    
    init() {
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        let channel = try! GRPCChannelPool.with(
            target: .host("localhost", port: 50051),
            transportSecurity: .plaintext,
            eventLoopGroup: group
        )
        
        self.client = Org_Signal_Registration_Ldap_Rpc_LdapValidationServiceAsyncClient(channel: channel)
    }
    
    func validateCredentials(userId: String, password: String, isEntraId: Bool) async throws -> ValidationResult {
        var request = Org_Signal_Registration_Ldap_Rpc_ValidateCredentialsRequest()
        request.userId = userId
        request.password = password
        
        do {
            let response = try await client.validateCredentials(request)
            
            if let error = response.error {
                return ValidationResult(
                    isValid: false,
                    phoneNumber: nil,
                    errorMessage: error.message
                )
            } else {
                return ValidationResult(
                    isValid: true,
                    phoneNumber: response.phoneNumber,
                    errorMessage: nil
                )
            }
        } catch {
            throw error
        }
    }
}
