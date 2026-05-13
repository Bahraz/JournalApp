import Foundation

// Upewnij się, że używasz 'final class', aby ViewModele widziały te same zmiany
final class Database: Codable {
    var users: [User]
    var subjects: [Subject]  // <-- TUTAJ MUSI BYĆ [Subject], a nie [String]
    var grades: [Grade]
    var entries: [Entry]

    init(users: [User], subjects: [Subject], grades: [Grade], entries: [Entry]) {
        self.users = users
        self.subjects = subjects
        self.grades = grades
        self.entries = entries
    }
}