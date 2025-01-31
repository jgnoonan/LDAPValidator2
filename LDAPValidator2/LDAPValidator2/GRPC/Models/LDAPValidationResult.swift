import Foundation

public struct LDAPValidationResult {
    public let isValid: Bool
    public let phoneNumber: String?
    
    public init(isValid: Bool, phoneNumber: String?) {
        self.isValid = isValid
        self.phoneNumber = phoneNumber
    }
}
