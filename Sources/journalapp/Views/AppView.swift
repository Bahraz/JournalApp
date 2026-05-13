import Foundation

class AppView {
    func clearScreen() {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "C:\\Windows\\System32\\cmd.exe")
        process.arguments = ["/c", "cls"]
        try? process.run()
        process.waitUntilExit()
    }

    func showMainMenu(for user: User) {
        clearScreen()
        print("=== E-DZIENNIK | \(user.username) [\(user.role.rawValue.uppercased())] ===")
        print("---------------------------------------------------------")
        
        if user.role == .admin {
            print("1. Zarządzanie Użytkownikami")
            print("2. Zarządzanie Przedmiotami")
        } else if user.role == .teacher {
            print("1. Zarządzanie Ocenami")
            print("2. Zarządzanie Uwagami")
            print("3. Przegląd raportów uczniów")
        } else if user.role == .student {
            print("1. Moje Oceny i Uwagi")
        }
        
        print("0. Wyloguj")
        print("---------------------------------------------------------")
        print("Wybierz sekcję: ", terminator: "")
    }

    func showAdminUserMenu() {
        clearScreen()
        print("=== ZARZĄDZANIE UŻYTKOWNIKAMI ===")
        print("1. Dodaj nowego użytkownika")
        print("2. Lista użytkowników")
        print("3. Edytuj użytkownika")
        print("4. Resetuj hasło użytkownika")
        print("5. Usuń użytkownika")
        print("0. Powrót")
        print("---------------------------------")
        print("Wybierz opcję: ", terminator: "")
    }

    func showAdminSubjectMenu() {
        clearScreen()
        print("=== ZARZĄDZANIE PRZEDMIOTAMI ===")
        print("1. Dodaj nowy przedmiot")
        print("2. Lista przedmiotów")
        print("3. Edytuj przedmiot")
        print("4. Usuń przedmiot")
        print("0. Powrót")
        print("---------------------------------")
        print("Wybierz opcję: ", terminator: "")
    }

    func showTeacherGradeMenu() {
        clearScreen()
        print("=== ZARZĄDZANIE OCENAMI ===")
        print("1. Wystaw nową ocenę")
        print("2. Edytuj istniejącą ocenę")
        print("0. Powrót")
        print("---------------------------")
        print("Wybierz opcję: ", terminator: "")
    }

    func showTeacherEntryMenu() {
        clearScreen()
        print("=== ZARZĄDZANIE UWAGAMI ===")
        print("1. Dodaj nową uwagę (wpis)")
        print("0. Powrót")
        print("---------------------------")
        print("Wybierz opcję: ", terminator: "")
    }

    func getInput(prompt: String) -> String {
        print(prompt, terminator: "")
        return readLine() ?? ""
    }
    
    func waitForEnter() {
        print("\nWciśnij ENTER, aby kontynuować...", terminator: "")
        _ = readLine()
    }
}