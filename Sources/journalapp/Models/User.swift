import Foundation

enum Role: String, Codable {
    case admin, teacher, student
}

struct User: Codable {
    let id: UUID
    let username: String
    var firstName: String
    var lastName: String 
    var passwordHash: String
    var role: Role
}