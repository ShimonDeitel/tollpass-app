import Foundation
import Combine

final class TollPassStore: ObservableObject {
    static let freeTierLimit = 20

    @Published var transponders: [Transponder] = [] { didSet { persist() } }

    private let fileURL: URL

    init() {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: support, withIntermediateDirectories: true)
        fileURL = support.appendingPathComponent("tollpassstore.json")
        load()
    }

    var isAtFreeLimit: Bool { transponders.count >= Self.freeTierLimit }

    func canAdd(isPro: Bool) -> Bool {
        isPro || transponders.count < Self.freeTierLimit
    }

    func add(_ entry: Transponder, isPro: Bool) -> Bool {
        guard canAdd(isPro: isPro) else { return false }
        transponders.append(entry)
        return true
    }

    func remove(at offsets: IndexSet) {
        transponders.remove(atOffsets: offsets)
    }

    func update(_ entry: Transponder) {
        if let idx = transponders.firstIndex(where: { $0.id == entry.id }) {
            transponders[idx] = entry
        }
    }

    private func seedIfNeeded() {
        if transponders.isEmpty {
            transponders = [Self.sampleSeed]
        }
    }

    private func persist() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(PersistedState(transponders: transponders)) {
            try? data.write(to: fileURL)
        }
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else {
            seedIfNeeded()
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let state = try? decoder.decode(PersistedState.self, from: data) {
            self.transponders = state.transponders
            
        }
        seedIfNeeded()
    }

    struct PersistedState: Codable {
        var transponders: [Transponder]
        
    }
    static let sampleSeed = Transponder(name: "Main Transponder", region: "Northeast", balance: 25.0, topUps: [])
}
