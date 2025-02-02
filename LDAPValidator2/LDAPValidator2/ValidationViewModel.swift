import Foundation
import GRPC
import Logging

@MainActor
class ValidationViewModel: ObservableObject {
    @Published var userId = ""
    @Published var password = ""
    @Published var phoneNumber = ""
    @Published var isValidating = false
    @Published var validationResult = ""
    @Published var selectedAuthType = AuthType.ldap
    
    private let validationClient: ValidationServiceClient
    
    enum AuthType: String, CaseIterable {
        case ldap = "LDAP"
        case entraId = "Entra ID"
    }
    
    init() {
        validationClient = ValidationServiceClient()
    }
    
    @MainActor
    func validateCredentials() async {
        guard !userId.isEmpty && !password.isEmpty else { return }
        
        isValidating = true
        validationResult = ""
        
        let logger = Logger(label: "com.valuelabs.ldapvalidator.viewmodel")
        logger.info("Starting validation for user: \(userId), auth type: \(selectedAuthType.rawValue)")
        
        do {
            let client = ValidationServiceClient()
            let isEntraId = selectedAuthType == .entraId
            
            logger.info("Calling validation service...")
            let result = try await client.validateCredentials(userId: userId, password: password, isEntraId: isEntraId)
            
            if result.isValid {
                logger.info("Validation successful")
                if let phoneNumber = result.phoneNumber {
                    logger.info("Phone number retrieved: \(phoneNumber)")
                    validationResult = "Validation Successful!\nPhone Number: \(phoneNumber)"
                } else {
                    logger.warning("No phone number in successful response")
                    validationResult = "Validation Successful but no phone number found"
                }
            } else {
                logger.error("Validation failed: \(result.errorMessage ?? "No error message")")
                validationResult = "\(selectedAuthType.rawValue) Validation Failed: \(result.errorMessage ?? "Unknown error")"
            }
        } catch {
            logger.error("Validation threw error: \(error)")
            validationResult = "Error: \(error.localizedDescription)"
        }
        
        isValidating = false
    }
}
