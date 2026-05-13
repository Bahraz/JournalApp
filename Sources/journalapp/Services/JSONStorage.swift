import Foundation

final class JSONStorage: Sendable {
    private var fileURL: URL {
        return URL(fileURLWithPath: "Sources/Database/journalappdata.json")
    }

    func save(db: Database) throws {
        let directoryURL = fileURL.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: directoryURL.path) {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(db)
        try data.write(to: fileURL)
    }

    func load() throws -> Database {
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            let hashedAdminPassword = SecurityHelper.hashPassword("admin123")
            
            let admin = User(
                id: UUID(), 
                username: "admin", 
                firstName: "Główny",
                lastName: "Administrator",
                passwordHash: hashedAdminPassword, 
                role: .admin
            )
            
            let newDB = Database(
                users: [admin], 
                subjects: [], 
                grades: [], 
                entries: []
            )
            
            try save(db: newDB)
            return newDB
        }
        
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(Database.self, from: data)
    }
}