import Foundation

// User role
enum Role: String, Codable {
    case admin, teacher, student
}

// User model
struct User: Codable {
    let id: UUID
    let username: String
    var firstName: String // Nowe pole
    var lastName: String  // Nowe pole
    var passwordHash: String
    var role: Role
}