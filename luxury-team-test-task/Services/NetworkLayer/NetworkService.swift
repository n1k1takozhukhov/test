import Foundation

protocol NetworkServiceProtocol {
    func fetchDataFromServer() async throws -> [StockModel]
}

struct NetworkService: NetworkServiceProtocol {

    // MARK: - Network Client
    let networkClient: NetworkClient

    // MARK: - Init
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    // MARK: - Fetch methods
    func fetchDataFromServer() async throws -> [StockModel] {
        // MOCK DATA FOR DEBUGGING
        return [
            StockModel(symbol: "AAPL", name: "Apple Inc.", price: 180.0, change: 1.2, changePercent: 0.67, logo: "", isFavorite: false),
            StockModel(symbol: "GOOG", name: "Alphabet Inc.", price: 2700.0, change: -15.0, changePercent: -0.55, logo: "", isFavorite: true)
        ]
    }
}

// MARK: - Supporting methods
private extension NetworkService {
    func responseMapping(_ response: [JsonResponse]) -> [StockModel] {
        return response.map { $0.toStockModel() }
    }
}
