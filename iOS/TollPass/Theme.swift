import SwiftUI

/// Unique visual identity for Roadtrip Toll Pass.
enum Theme {
    static let background = Color(red: 0.102, green: 0.165, blue: 0.102)
    static let accent = Color(red: 0.373, green: 0.749, blue: 0.420)
    static let secondary = Color(red: 0.624, green: 0.796, blue: 0.627)
    static let cardBackground = background.opacity(0.92)

    static let titleFont = Font.system(.title2, design: .default).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .default).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .default)
    static let captionFont = Font.system(.caption, design: .default)

    static let cornerRadius: CGFloat = 16
    static let spacing: CGFloat = 12
}
