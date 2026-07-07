import Foundation

struct TopUp: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var amount: Double
    var date: Date = Date()
    var note: String = ""
}

struct Transponder: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var region: String
    var balance: Double
    var topUps: [TopUp] = []
    var createdAt: Date = Date()
}
