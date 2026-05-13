import Foundation

final class Database: Codable {
    var users: [User]
    var subjects: [Subject]
    var grades: [Grade]
    var entries: [Entry]

    init(users: [User], subjects: [Subject], grades: [Grade], entries: [Entry]) {
        self.users = users
        self.subjects = subjects
        self.grades = grades
        self.entries = entries
    }
}