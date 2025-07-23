import UIKit

struct StockModel: Codable, Hashable {

    // MARK: Properties

    let symbol: String
    let name: String
    let price: Double
    let change: Double
    let changesPercentage: Double

    // MARK: Initializers

    init(
        symbol: String,
        name: String,
        price: Double,
        change: Double,
        changesPercentage: Double,
    ) {
        self.symbol = symbol
        self.name = name
        self.price = price
        self.change = change
        self.changesPercentage = changesPercentage
    }

    init(from entity: FavoriteStock) {
        self.symbol = entity.symbol ?? ""
        self.name = entity.name ?? ""
        self.price = entity.price
        self.change = entity.change
        self.changesPercentage = entity.changesPercentage
    }

    // MARK: Helpers

    func changeInfo() -> (text: String, color: UIColor) {
        let sign = change >= 0 ? "+" : "-"
        let absChange = abs(change)
        let absPercent = abs(changesPercentage)

        let formattedText = String(format: "%@$%.2f (%.2f%%)", sign, absChange, absPercent).replacingOccurrences(of: ".", with: ",")
        let color: UIColor = change >= 0 ? .systemGreen : .systemRed

        return (formattedText, color)
    }

}
