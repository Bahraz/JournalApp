import Foundation

class AuthService {
    private var database: Database
    
    private(set) var currentUser: User?

    init(database: Database) {
        self.database = database
    }

    func login(username: String, passwordRaw: String) -> Bool {
        let hashedPassword = SecurityHelper.hashPassword(passwordRaw)
        
        if let user = database.users.first(where: { $0.username == username && $0.passwordHash == hashedPassword }) {
            self.currentUser = user
            return true
        }
        return false
    }

    func logout() {
        self.currentUser = nil
    }
    
    func hasRole(_ role: Role) -> Bool {
        return currentUser?.role == role
    }
}