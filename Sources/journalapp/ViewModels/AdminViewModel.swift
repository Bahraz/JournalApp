import Foundation

class AdminViewModel {
    private var database: Database
    private let storage: JSONStorage
    private let view: AppView
    
    init(database: Database, storage: JSONStorage, view: AppView) {
        self.database = database
        self.storage = storage
        self.view = view
    }

    func manageUsersFlow() {
        var back = false
        while !back {
            view.showAdminUserMenu()
            let choice = readLine() ?? ""
            switch choice {
            case "1": addNewUser()
            case "2": 
                showUsers()
                view.waitForEnter()
            case "3": editUser()
            case "4": resetUserPassword()
            case "5": deleteUser()
            case "0": back = true
            default: break
            }
        }
    }
    
    func manageSubjectsFlow() {
        var back = false
        while !back {
            view.showAdminSubjectMenu()
            let choice = readLine() ?? ""
            switch choice {
            case "1": addNewSubject()
            case "2": 
                showSubjects()
                view.waitForEnter()
            case "3": editSubject()
            case "4": deleteSubject()
            case "0": back = true
            default: break
            }
        }
    }

    private func addNewUser() {
        let n = view.getInput(prompt: "Login (username): ")
        let fName = view.getInput(prompt: "Imię: ")
        let lName = view.getInput(prompt: "Nazwisko: ")
        let p = view.getInput(prompt: "Hasło: ")
        
        print("Rola (1-Admin, 2-Nauczyciel, 3-Uczeń): ", terminator: "")
        let r = readLine() ?? ""
        let role: Role = (r == "1") ? .admin : (r == "2") ? .teacher : .student
        
        let hashed = SecurityHelper.hashPassword(p)
        
        let newUser = User(
            id: UUID(), 
            username: n, 
            firstName: fName, 
            lastName: lName, 
            passwordHash: hashed, 
            role: role
        )
        
        database.users.append(newUser)
        saveAndInfo("Dodano użytkownika: \(fName) \(lName).")
    }

    private func showUsers() {
        print("\n--- LISTA UŻYTKOWNIKÓW ---")
        if database.users.isEmpty {
            print("Brak użytkowników w bazie.")
        } else {
            database.users.enumerated().forEach { 
                print("\($0). [\($1.role.rawValue.uppercased())] \($1.firstName) \($1.lastName) (@\($1.username))") 
            }
        }
    }

    private func editUser() {
        print("\n--- EDYCJA UŻYTKOWNIKA ---")
        showUsers()
        
        let idxStr = view.getInput(prompt: "Numer indeksu do edycji: ")
        if let idx = Int(idxStr), idx >= 0 && idx < database.users.count {
            let user = database.users[idx]
            
            let newLogin = view.getInput(prompt: "Nowy login (Enter - bez zmian): ")
            let newFName = view.getInput(prompt: "Nowe imię (Enter - bez zmian): ")
            let newLName = view.getInput(prompt: "Nowe nazwisko (Enter - bez zmian): ")
            
            print("Nowa rola (1-Admin, 2-Nauczyciel, 3-Uczeń, Enter - bez zmian): ", terminator: "")
            let r = readLine() ?? ""
            
            let finalLogin = newLogin.isEmpty ? user.username : newLogin
            let finalFName = newFName.isEmpty ? user.firstName : newFName
            let finalLName = newLName.isEmpty ? user.lastName : newLName
            
            var finalRole = user.role
            if r == "1" { finalRole = .admin }
            else if r == "2" { finalRole = .teacher }
            else if r == "3" { finalRole = .student }
            
            database.users[idx] = User(
                id: user.id, 
                username: finalLogin, 
                firstName: finalFName, 
                lastName: finalLName, 
                passwordHash: user.passwordHash, 
                role: finalRole
            )
            saveAndInfo("Dane użytkownika zaktualizowane.")
        } else {
            print("Nieprawidłowy indeks.")
            view.waitForEnter()
        }
    }

    private func resetUserPassword() {
        print("\n--- RESETOWANIE HASŁA ---")
        showUsers()
        
        let idxStr = view.getInput(prompt: "Podaj indeks użytkownika: ")
        if let idx = Int(idxStr), idx >= 0 && idx < database.users.count {
            let newPass = view.getInput(prompt: "Podaj nowe hasło: ")
            let hashed = SecurityHelper.hashPassword(newPass)
            
            database.users[idx].passwordHash = hashed
            saveAndInfo("Hasło zostało pomyślnie zresetowane.")
        } else {
            print("Nieprawidłowy indeks.")
            view.waitForEnter()
        }
    }

    private func deleteUser() {
        print("\n--- USUWANIE UŻYTKOWNIKA ---")
        if database.users.isEmpty {
            print("Brak użytkowników do usunięcia.")
            view.waitForEnter()
            return
        }
        
        showUsers()
        
        let idxStr = view.getInput(prompt: "Podaj indeks użytkownika do usunięcia (lub Enter, aby anulować): ")
        
        if let idx = Int(idxStr), idx >= 0 && idx < database.users.count {
            let userToDelete = database.users[idx]
            
            let confirm = view.getInput(prompt: "Czy na pewno chcesz usunąć użytkownika \(userToDelete.firstName) \(userToDelete.lastName) (@\(userToDelete.username))? (t/n): ")
            
            if confirm.lowercased() == "t" {
                let deletedName = userToDelete.username
                database.users.remove(at: idx)
                saveAndInfo("Usunięto użytkownika: \(deletedName).")
            } else {
                print("Anulowano operację usuwania.")
                view.waitForEnter()
            }
        } else {
            print("Nieprawidłowy indeks.")
            view.waitForEnter()
        }
    }

    private func addNewSubject() {
        let name = view.getInput(prompt: "Nazwa przedmiotu: ")
        if !name.isEmpty {
            database.subjects.append(Subject(id: UUID(), name: name))
            saveAndInfo("Dodano przedmiot: \(name).")
        } else {
            print("Nazwa nie może być pusta.")
            view.waitForEnter()
        }
    }

    private func showSubjects() {
        print("\n--- LISTA PRZEDMIOTÓW ---")
        if database.subjects.isEmpty {
            print("Brak przedmiotów w bazie.")
        } else {
            database.subjects.enumerated().forEach { print("\($0). \($1.name)") }
        }
    }

    private func editSubject() {
        print("\n--- EDYCJA PRZEDMIOTU ---")
        showSubjects() 
        
        let idxStr = view.getInput(prompt: "Numer indeksu do edycji: ")
        if let idx = Int(idxStr), idx >= 0 && idx < database.subjects.count {
            let oldSubject = database.subjects[idx]
            
            let newName = view.getInput(prompt: "Nowa nazwa przedmiotu (Enter - bez zmian): ")
            
            let finalName = newName.isEmpty ? oldSubject.name : newName
            
            database.subjects[idx] = Subject(id: oldSubject.id, name: finalName)
            saveAndInfo("Przedmiot zaktualizowany.")
        } else {
            print("Nieprawidłowy indeks.")
            view.waitForEnter()
        }
    }

    private func deleteSubject() {
        print("\n--- USUWANIE PRZEDMIOTU ---")
        showSubjects()
        
        let idxStr = view.getInput(prompt: "Indeks przedmiotu do usunięcia (lub Enter, aby anulować): ")
        
        if let idx = Int(idxStr), idx >= 0 && idx < database.subjects.count {
            let subjectName = database.subjects[idx].name
            
            let confirm = view.getInput(prompt: "Czy na pewno chcesz usunąć przedmiot '\(subjectName)'? (t/n): ")
            
            if confirm.lowercased() == "t" {
                database.subjects.remove(at: idx)
                saveAndInfo("Przedmiot '\(subjectName)' został usunięty.")
            } else {
                print("Anulowano usuwanie.")
                view.waitForEnter()
            }
        } else {
            print("Nieprawidłowy indeks.")
            view.waitForEnter()
        }
    }

    private func saveAndInfo(_ msg: String) {
        do {
            try storage.save(db: database)
            print(msg)
        } catch {
            print("Błąd zapisu do bazy: \(error)")
        }
        view.waitForEnter()
    }
}