import Foundation

protocol APIService {

    func fetchMockStocks(_ completion: @escaping (Result<[StockModel], any Error>) -> Void)
    func fetchStocks(completion: @escaping (Result<[StockModel], Error>) -> Void)
    func imageURL(for symbol: String) -> URL?

}

// MARK: - APIService

extension APIServiceImplementation: APIService {

    func fetchMockStocks(_ completion: @escaping (Result<[StockModel], any Error>) -> Void) {
        request(
            endpoint: Constants.Endpoint.stocksJSON,
            responseType: [StockModel].self
        ) { result in
            completion(result)
        }
    }

    func fetchStocks(completion: @escaping (Result<[StockModel], Error>) -> Void) {
        guard let url = URL(string: Constants.Endpoint.stocksJSON) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        self.completion = completion
        largeJSONSession.dataTask(with: url).resume()
    }

    func imageURL(for symbol: String) -> URL? {
        URL(string: "\(Constants.Endpoint.getSymbolImage)\(symbol).png?apikey=\(Constants.APIkeys.key)")
    }

}
