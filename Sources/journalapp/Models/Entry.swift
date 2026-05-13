import Foundation

struct Entry: Codable {
    let id: UUID
    let date: Date
    let text: String
    let studentID: UUID
    let teacherID: UUID
}