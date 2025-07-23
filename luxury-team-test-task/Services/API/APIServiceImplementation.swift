import Foundation

final class APIServiceImplementation: NSObject {

    // MARK: Properties

    enum Constants {
        enum APIkeys {
            static let key = "RidMALI8B2P13jY3H3D4ey0suWnDMdlN"
        }
        enum Endpoint {
            static let stocksJSON = "https://financialmodelingprep.com/api/v3/symbol/NASDAQ?apikey=\(Constants.APIkeys.key)"
            static let getSymbolImage = "https://financialmodelingprep.com/image-stock/"
        }
    }

    lazy var largeJSONSession: URLSession = {
        let streamParser = LargeJSONStreamParser(limit: limit) { [weak self] result in
            guard let result else { return }
            self?.completion?(result)
        }
        let session = URLSession(configuration: .default, delegate: streamParser, delegateQueue: nil)
        return session
    }()
    var completion: ((Result<[StockModel], Error>) -> Void)?

    private var limit: Int = 100000

    // MARK: Events

    func request<R: Codable>(
        endpoint: String,
        responseType: R.Type,
        body: [String: Any] = [:],
        headers: [String: String] = [:],
        completion: @escaping (Result<R, Error>) -> Void
    ) {
        do {
            guard let url = URL(string: endpoint) else {
                completion(.failure(NetworkError.invalidURL))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }

            if !body.isEmpty {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            }

            LogsService.network(body, data: nil)

            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    LogsService.error("Request failed: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }

                guard let data else {
                    LogsService.error("Response data is nil")
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.emptyResponse))
                    }
                    return
                }

                LogsService.network(body, data: data)

                do {
                    let decoded = try JSONDecoder().decode(R.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decoded))
                    }
                }
                catch {
                    LogsService.error("Decoding failed: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }

            }.resume()

        }
        catch {
            LogsService.error("Token fetch failed: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }

}

// MARK: Enums

enum NetworkError: Error {

    case invalidURL
    case emptyResponse

}
