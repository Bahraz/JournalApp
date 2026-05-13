import Foundation

struct Grade: Codable {
    let id: UUID
    var value: Int
    let studentID: UUID
    let teacherID: UUID
    let subjectID: UUID
    let date: Date
}