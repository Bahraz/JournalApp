import Foundation

let storage = JSONStorage()
var database = (try? storage.load()) ?? Database(users: [], subjects: [], grades: [], entries: [])

let appView = AppView()
let authService = AuthService(database: database)
let loginVM = LoginViewModel(authService: authService)

var shouldExitApp = false

while !shouldExitApp {
    
    if let user = authService.currentUser {
        appView.showMainMenu(for: user)
        let choice = readLine() ?? ""
        
        switch user.role {
        case .admin:
            let adminVM = AdminViewModel(database: database, storage: storage, view: appView)
            
            if choice == "1" { 
                adminVM.manageUsersFlow() 
            } else if choice == "2" { 
                adminVM.manageSubjectsFlow() 
            } else if choice == "0" { 
                authService.logout() 
            }
            
        case .teacher:
            let teacherVM = TeacherViewModel(
                database: database, 
                storage: storage, 
                view: appView, 
                teacherID: user.id
            )
            
            if choice == "1" { 
                teacherVM.manageGradesFlow()
            } else if choice == "2" {
                teacherVM.manageEntriesFlow()
            } else if choice == "3" {
                teacherVM.viewGradesAndEntries()
            } else if choice == "0" { 
                authService.logout() 
            }
            
        case .student:
            if choice == "0" { 
                authService.logout() 
            } else { 
                print("\n[i] Moduł ucznia (przegląd ocen) zostanie zaimplementowany w przyszłości.") 
                appView.waitForEnter() 
            }
        }
        
    } else {
        appView.clearScreen()
        _ = loginVM.startLoginProcess()
    }
}