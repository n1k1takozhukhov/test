import Foundation

struct JsonResponse: Codable {
    let symbol: String
    let name: String
    let price: Double
    let change: Double
    let changePercent: Double
    let logo: String

    func toStockModel() -> StockModel {
        return StockModel(symbol: symbol, name: name, price: price, change: change, changePercent: changePercent, logo: logo, isFavorite: false)
    }
}
