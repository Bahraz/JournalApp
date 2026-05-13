import Foundation

class TeacherViewModel {
    private var database: Database
    private let storage: JSONStorage
    private let view: AppView
    private let currentTeacherID: UUID
    
    init(database: Database, storage: JSONStorage, view: AppView, teacherID: UUID) {
        self.database = database
        self.storage = storage
        self.view = view
        self.currentTeacherID = teacherID
    }
    
    func manageGradesFlow() {
        var back = false
        while !back {
            view.showTeacherGradeMenu()
            let choice = readLine() ?? ""
            switch choice {
            case "1": addGradeFlow()
            case "2": editGradeFlow()
            case "0": back = true
            default: break
            }
        }
    }

    func manageEntriesFlow() {
        var back = false
        while !back {
            view.showTeacherEntryMenu()
            let choice = readLine() ?? ""
            switch choice {
            case "1": addEntryFlow()
            case "0": back = true
            default: break
            }
        }
    }

    private func addGradeFlow() {
        showStudents()
        guard let student = selectStudent(), let subject = selectSubject() else { return }
        
        let valueStr = view.getInput(prompt: "Podaj ocenę (1-6): ")
        if let value = Int(valueStr), value >= 1 && value <= 6 {
            let newGrade = Grade(id: UUID(), value: value, studentID: student.id, teacherID: currentTeacherID, subjectID: subject.id, date: Date())
            database.grades.append(newGrade)
            saveAndInfo("Dodano ocenę \(value).")
        }
    }

    private func editGradeFlow() {
        showStudents()
        guard let student = selectStudent() else { return }
        let studentGrades = database.grades.filter { $0.studentID == student.id && $0.teacherID == currentTeacherID }
        
        if studentGrades.isEmpty {
            print("Brak Twoich ocen dla tego ucznia.")
            view.waitForEnter()
            return
        }
        
        print("\n--- TWOJE OCENY UCZNIA \(student.firstName.uppercased()) \(student.lastName.uppercased()) ---")
        studentGrades.enumerated().forEach { i, g in
            let subName = database.subjects.first(where: { $0.id == g.subjectID })?.name ?? "Nieznany"
            print("\(i). [\(subName)] Ocena: \(g.value)")
        }
        
        let idxStr = view.getInput(prompt: "Wybierz indeks oceny (Enter - anuluj): ")
        if let idx = Int(idxStr), idx >= 0 && idx < studentGrades.count {
            let oldGrade = studentGrades[idx]
            let valStr = view.getInput(prompt: "Nowa ocena (1-6, Enter - brak zmian): ")
            
            let finalVal = valStr.isEmpty ? oldGrade.value : (Int(valStr) ?? oldGrade.value)
            
            if let dbIdx = database.grades.firstIndex(where: { $0.id == oldGrade.id }) {
                database.grades[dbIdx].value = finalVal
                saveAndInfo("Zaktualizowano ocenę.")
            }
        }
    }

    private func addEntryFlow() {
        showStudents()
        guard let student = selectStudent() else { return }
        let text = view.getInput(prompt: "Treść uwagi (Enter - anuluj): ")
        
        if !text.isEmpty {
            let newEntry = Entry(id: UUID(), date: Date(), text: text, studentID: student.id, teacherID: currentTeacherID)
            database.entries.append(newEntry)
            saveAndInfo("Dodano uwagę.")
        }
    }

    func viewGradesAndEntries() {
        showStudents()
        guard let student = selectStudent() else { return }
        
        print("\n--- RAPORT: \(student.firstName) \(student.lastName) ---")
        let grades = database.grades.filter { $0.studentID == student.id }
        let entries = database.entries.filter { $0.studentID == student.id }
        
        print("\nOCENY:")
        if grades.isEmpty { print("- Brak ocen.") }
        else {
            grades.forEach { g in
                let sub = database.subjects.first(where: { $0.id == g.subjectID })?.name ?? "Nieznany"
                print("- [\(sub)]: \(g.value)")
            }
        }
        
        print("\nUWAGI:")
        if entries.isEmpty { print("- Brak uwag.") }
        else {
            entries.forEach { print("- [\($0.date.formatted(date: .abbreviated, time: .shortened))]: \($0.text)") }
        }
        
        view.waitForEnter()
    }

    private func showStudents() {
        let students = database.users.filter { $0.role == .student }
        print("\n--- LISTA UCZNIÓW ---")
        if students.isEmpty { print("Brak uczniów.") }
        else { students.enumerated().forEach { print("\($0). \($1.firstName) \($1.lastName)") } }
    }

    private func selectStudent() -> User? {
        let students = database.users.filter { $0.role == .student }
        if students.isEmpty { return nil }
        let idxStr = view.getInput(prompt: "Podaj indeks ucznia: ")
        if let idx = Int(idxStr), idx >= 0 && idx < students.count { return students[idx] }
        return nil
    }

    private func selectSubject() -> Subject? {
        if database.subjects.isEmpty {
            print("Brak przedmiotów w bazie."); view.waitForEnter(); return nil
        }
        print("\n--- LISTA PRZEDMIOTÓW ---")
        database.subjects.enumerated().forEach { print("\($0). \($1.name)") }
        let idxStr = view.getInput(prompt: "Podaj indeks przedmiotu: ")
        if let idx = Int(idxStr), idx >= 0 && idx < database.subjects.count { return database.subjects[idx] }
        return nil
    }

    private func saveAndInfo(_ msg: String) {
        try? storage.save(db: database)
        print(msg)
        view.waitForEnter()
    } 
}