import Foundation

struct Class: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var name: String
    var allowedAbsences: Int
    var absencesUsed: Int

    init(id: UUID = UUID(), createdAt: Date = Date(), name: String, allowedAbsences: Int, absencesUsed: Int) {
        self.id = id
        self.createdAt = createdAt
        self.name = name
        self.allowedAbsences = allowedAbsences
        self.absencesUsed = absencesUsed
    }
}
