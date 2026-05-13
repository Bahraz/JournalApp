import Foundation

// Main Controller database
struct Database: Codable {
    var users: [User]
    var subjects: [String]
    var grades: [Grade]
    var entries: [Entry]
}