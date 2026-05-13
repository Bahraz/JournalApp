import Foundation

struct SecurityHelper {
    static func hashPassword(_ password: String) -> String {
        return Data(password.utf8).base64EncodedString()
    }
    
    static func verifyPassword(_ password: String, hash: String) -> Bool {
        return hashPassword(password) == hash
    }
}