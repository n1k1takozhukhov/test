import Foundation

struct StockModel: Codable, Equatable, Hashable {
    let symbol: String
    let name: String
    let price: Double
    let change: Double
    let changePercent: Double
    let logo: String
    var isFavorite: Bool = false

    func hash(into hasher: inout Hasher) {
        hasher.combine(symbol)
        hasher.combine(isFavorite)
    }

    static func == (lhs: StockModel, rhs: StockModel) -> Bool {
        lhs.symbol == rhs.symbol && lhs.isFavorite == rhs.isFavorite
    }
}
