import Foundation

let storage = JSONStorage()
var database = (try? storage.load()) ?? Database(users: [], subjects: [], grades: [], entries: [])

let appView = AppView()
let authService = AuthService(database: database)
let loginVM = LoginViewModel(authService: authService)
let adminVM = AdminViewModel(database: database, storage: storage, view: appView)

var shouldExitApp = false

while !shouldExitApp {
    if let user = authService.currentUser {
        appView.showMainMenu(for: user)
        let choice = readLine() ?? ""
        
        switch user.role {
        case .admin:
            if choice == "1" { adminVM.manageUsersFlow() }
            else if choice == "2" { adminVM.manageSubjectsFlow() }
            else if choice == "0" { authService.logout() }
            
        case .teacher:
            if choice == "0" { authService.logout() }
            else { print("Menu nauczyciela w budowie...") ; appView.waitForEnter() }
            
        case .student:
            if choice == "0" { authService.logout() }
            else { print("Menu ucznia w budowie...") ; appView.waitForEnter() }
        }
    } else {
        appView.clearScreen()
        _ = loginVM.startLoginProcess()
    }
}