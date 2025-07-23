import Foundation

/// This class serves to limit the size of JSON received from an external API, in case this is not done by the API.
final class LargeJSONStreamParser: NSObject, URLSessionDataDelegate {

    // MARK: Private

    private var buffer = Data()
    private var symbols: [StockModel] = []
    private var decoder = JSONDecoder()
    private var completion: ((Result<[StockModel], Error>) -> Void)?
    private let limit: Int

    // MARK: Initilizers

    init(
        limit: Int,
        completion: @escaping (Result<[StockModel], Error>?) -> Void
    ) {
        self.limit = limit
        self.completion = completion
    }

    // MARK: Events

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        buffer.append(data)

        while true {
            guard let (objectData, remaining) = extractNextJSONObject(from: buffer) else {
                break
            }

            buffer = remaining

            do {
                let symbol = try decoder.decode(StockModel.self, from: objectData)
                symbols.append(symbol)
            }
            catch {
                continue
            }

            if symbols.count >= limit {
                session.invalidateAndCancel()
                completion?(.success(symbols))
                completion = nil
                break
            }
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let completion else { return }

        if let error {
            completion(.failure(error))
        }
        else {
            completion(.success(symbols))
        }
        self.completion = nil
    }

    // MARK: Private

    private func extractNextJSONObject(from data: Data) -> (Data, Data)? {
        var trimmed = data

        while
            let first = trimmed.first,
            first == UInt8(ascii: "[") ||
                first == UInt8(ascii: ",") ||
                first == UInt8(ascii: " ") ||
                first == UInt8(ascii: "\n") ||
                first == UInt8(ascii: "\r") ||
                first == UInt8(ascii: "\t") {
            trimmed.removeFirst()
        }

        guard let start = trimmed.first, start == UInt8(ascii: "{") else {
            return nil
        }

        var depth = 0
        for (index, byte) in trimmed.enumerated() {
            if byte == UInt8(ascii: "{") {
                depth += 1
            }
            else if byte == UInt8(ascii: "}") {
                depth -= 1
                if depth == 0 {
                    let objectData = trimmed.prefix(index + 1)
                    let remaining = trimmed.dropFirst(index + 1)
                    return (Data(objectData), Data(remaining))
                }
            }
        }

        return nil
    }

}
