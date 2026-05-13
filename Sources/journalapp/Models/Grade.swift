import Foundation

// Grade model
struct Grade: Codable {
    let id: UUID
    let value: Double
    let studentID: UUID
    let teacherID: UUID
    let subjectID: UUID
    let date: Date
}