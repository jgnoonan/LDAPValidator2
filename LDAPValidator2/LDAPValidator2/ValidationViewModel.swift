import Foundation
import GRPC
import Logging

class ValidationViewModel: ObservableObject {
    @Published var userId = ""
    @Published var password = ""
    @Published var phoneNumber = ""
    @Published var isValidating = false
    @Published var validationResult = ""
    @Published var selectedAuthType = AuthType.ldap
    
    private let ldapClient: LDAPGRPCClient
    private let entraClient: EntraGRPCClient
    
    enum AuthType: String, CaseIterable {
        case ldap = "LDAP"
        case entraId = "Entra ID"
    }
    
    init() {
        let logger = Logger(label: "com.valuelabs.ldapvalidator")
        ldapClient = LDAPGRPCClient(logger: logger)
        entraClient = EntraGRPCClient(logger: logger)
    }
    
    func validateCredentials() async {
        isValidating = true
        validationResult = ""
        
        do {
            switch selectedAuthType {
            case .ldap:
                try await validateLDAP()
            case .entraId:
                try await validateEntraID()
            }
        } catch {
            validationResult = "Error: \(error.localizedDescription)"
        }
        
        isValidating = false
    }
    
    private func validateLDAP() async throws {
        let result = try await ldapClient.validateCredentials(userId: userId, password: password)
        if result.isValid {
            validationResult = "LDAP Validation Successful"
            phoneNumber = result.phoneNumber ?? ""
        } else {
            validationResult = "LDAP Validation Failed"
        }
    }
    
    private func validateEntraID() async throws {
        let result = try await entraClient.validateCredentials(userId: userId, password: password)
        if result.isValid {
            validationResult = "Entra ID Validation Successful"
            phoneNumber = result.phoneNumber ?? ""
        } else {
            validationResult = "Entra ID Validation Failed"
        }
    }
}
