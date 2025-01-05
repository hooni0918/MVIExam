import Foundation

struct Movie: Identifiable, Equatable {
    let id: String
    let rank: Int
    let title: String
    let audienceCount: Int
    let totalAudience: Int
    let rankIntensity: Int
}
