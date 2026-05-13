import Foundation

class StudentViewModel {
    private var database: Database
    private let view: AppView
    private let studentID: UUID
    
    init(database: Database, view: AppView, studentID: UUID) {
        self.database = database
        self.view = view
        self.studentID = studentID
    }
    
    // MARK: - Główny Flow Studenta
    func manageStudentFlow() {
        var back = false
        while !back {
            view.showStudentMenu()
            let choice = readLine() ?? ""
            switch choice {
            case "1": viewMyGrades()
            case "2": viewMyEntries()
            case "0": back = true
            default: break
            }
        }
    }
    
    private func viewMyGrades() {
        view.clearScreen()
        print("=== TWOJE OCENY ===")
        
        let myGrades = database.grades.filter { $0.studentID == studentID }
        
        if myGrades.isEmpty {
            print("Brak wystawionych ocen.")
        } else {
            // Grupowanie ocen po przedmiotach dla lepszej czytelności
            for subject in database.subjects {
                let subjectGrades = myGrades.filter { $0.subjectID == subject.id }
                if !subjectGrades.isEmpty {
                    let gradesStr = subjectGrades.map { String($0.value) }.joined(separator: ", ")
                    print("- \(subject.name): \(gradesStr)")
                }
            }
            
            // Obliczanie średniej
            let sum = myGrades.reduce(0) { $0 + $1.value }
            let average = Double(sum) / Double(myGrades.count)
            print("-------------------")
            print(String(format: "ŚREDNIA OCEN: %.2f", average))
        }
        view.waitForEnter()
    }
    
    private func viewMyEntries() {
        view.clearScreen()
        print("=== TWOJE UWAGI I WPISY ===")
        
        let myEntries = database.entries.filter { $0.studentID == studentID }
        
        if myEntries.isEmpty {
            print("Brak wpisów w Twoim dzienniczku.")
        } else {
            myEntries.forEach { entry in
                let dateStr = entry.date.formatted(date: .abbreviated, time: .shortened)
                print("- [\(dateStr)]: \(entry.text)")
            }
        }
        view.waitForEnter()
    }
}