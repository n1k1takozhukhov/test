import Foundation

protocol UDManagerProtocol {
    func addToFavorites(_ stock: StockModel)
    func removeFromFavorites(_ stock: StockModel)
    func loadFavoritesFromUD() -> [StockModel]
}

final class UDManager: UDManagerProtocol {

    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    private let defaults = UserDefaults.standard
    private let queue = DispatchQueue(label: "ru.luxuryTeam.UDManagerQueue", qos: .background)

    // MARK: - Init
    init(encoder: JSONEncoder, decoder: JSONDecoder) {
        self.encoder = encoder
        self.decoder = decoder
    }

    // MARK: - CRUD
    func addToFavorites(_ stock: StockModel) {
        queue.async { [weak self] in
            guard let self else { return }
            var favourites = loadFavoritesFromUD()
            if !favourites.contains(where: { $0.symbol == stock.symbol }) {
                favourites.append(stock)
                print("✅ Added to favourites: \(stock.symbol)")
            }

            saveFavouritesToUD(favourites)
        }
    }

    func removeFromFavorites(_ stock: StockModel) {
        queue.async { [weak self] in
            guard let self else { return }
            var favourites = loadFavoritesFromUD()
            favourites.removeAll(where: { $0.symbol == stock.symbol })
            print("✅ Removed from favourites \(stock.symbol)")

            saveFavouritesToUD(favourites)
        }
    }

    func loadFavoritesFromUD() -> [StockModel] {
        if let savedData = defaults.data(forKey: AppConstants.UserDefaultsKeys.favourites),
           let decoded = try? decoder.decode([StockModel].self, from: savedData) {
            print("✅ Loaded favourites from UD: \(decoded.count) items")
            return decoded
        } else {
            print("🔴 No data found in UD")
            return []
        }
    }
}

// MARK: - Supporting methods
private extension UDManager {
    func saveFavouritesToUD(_ data: [StockModel]) {
        queue.async { [weak self] in
            guard let self else { return }
            if let newData = try? encoder.encode(data) {
                defaults.set(newData, forKey: AppConstants.UserDefaultsKeys.favourites)
                print("✅ Data saved to UD")
            }
        }
    }
}

//    func saveAllChangesToUD() {
//        let favorites = mockData.filter { $0.isFavorite }
//        print(favorites)
//        saveFavouritesToUD(favorites)
//    }
