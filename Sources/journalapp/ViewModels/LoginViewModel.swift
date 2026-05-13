import Foundation

class LoginViewModel {
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func startLoginProcess() -> User? {
        print("\n=== SYSTEM E-DZIENNIK: LOGOWANIE ===")
        
        print("Login: ", terminator: "")
        let username = readLine() ?? ""
        
        print("Hasło: ", terminator: "")
        let password = readLine() ?? ""
        
        if authService.login(username: username, passwordRaw: password) {
            return authService.currentUser
        } else {
            print("Błąd: Nieprawidłowy login lub hasło.")
            return nil
        }
    }
}