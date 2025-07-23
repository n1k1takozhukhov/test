import CoreData

protocol CoreDataService {

    func addToFavorites(_ stock: StockModel)
    func removeFromFavorites(symbol: String)
    func isFavorite(symbol: String) -> Bool
    func fetchFavoriteStocks() -> [StockModel]

}

// MARK: - CoreDataService

extension CoreDataServiceImplementation: CoreDataService {

    func addToFavorites(_ stock: StockModel) {
        LogsService.warning("Attempt to add to favorites: \(stock.symbol)")

        guard !isFavorite(symbol: stock.symbol) else {
            LogsService.error("Symbol \(stock.symbol) is already in favorites")
            return
        }

        let favorite = FavoriteStock(context: context)
        favorite.symbol = stock.symbol
        favorite.name = stock.name
        favorite.price = stock.price
        favorite.change = stock.change
        favorite.changesPercentage = stock.changesPercentage

        saveContext()
    }

    func removeFromFavorites(symbol: String) {
        LogsService.warning("Attempt to remove from favorites: \(symbol)")

        let request: NSFetchRequest<FavoriteStock> = FavoriteStock.fetchRequest()
        request.predicate = NSPredicate(format: "symbol == %@", symbol)

        do {
            let result = try context.fetch(request)

            if let objectToDelete = result.first {
                context.delete(objectToDelete)
                saveContext()
                LogsService.info("Successfully removed symbol \(symbol) from favorites")
            }
            else {
                LogsService.error("Symbol \(symbol) not found in favorites")
            }
        }
        catch {
            LogsService.error("Failed to fetch or delete symbol \(symbol): \(error.localizedDescription)")
        }
    }

    func isFavorite(symbol: String) -> Bool {
        let request: NSFetchRequest<FavoriteStock> = FavoriteStock.fetchRequest()
        request.predicate = NSPredicate(format: "symbol == %@", symbol)

        return (try? context.count(for: request)) ?? 0 > 0
    }

    func fetchFavoriteStocks() -> [StockModel] {
        LogsService.warning("Attempt to get all favorites")

        let request: NSFetchRequest<FavoriteStock> = FavoriteStock.fetchRequest()

        guard let favorites = try? context.fetch(request) else {
            LogsService.info("There are no favorites")
            return []
        }

        let result = favorites.map { StockModel(from: $0) }

        LogsService.info("Succsesfully get all favorites \n-> RESULT: \(result)")

        return result
    }

}
