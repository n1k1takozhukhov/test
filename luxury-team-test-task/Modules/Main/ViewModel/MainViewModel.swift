import Foundation

protocol MainViewModelling: AnyObject {
    func viewLoaded()
    func eventHandler(_ event: MainViewModelEvent)
}

enum MainViewModelEvent {
    case showMoreButtonTapped
    case categoryChanged(Int)
    case addToFavoriteButtonTapped(StockModel)
    case filteringModeStarted(String)
    case errorLoadingData
}

final class MainViewModel: MainViewModelling {

    // MARK: - Properties
    private var data: [StockModel] = []
    private var favorites: [StockModel] = []
    private var displayData: [StockModel] = []

    private var isFavoritesChosen = false
    private var isFiltering = false
    private var filterText: String = ""

    private var networkService: NetworkServiceProtocol
    private var udManager: UDManagerProtocol

    weak var view: MainViewController?

    // MARK: - Init
    init(networkService: NetworkServiceProtocol, udManager: UDManagerProtocol) {
        self.networkService = networkService
        self.udManager = udManager
        getFavoritesFromUD()
    }
}

// MARK: - MainViewModelling
extension MainViewModel {
    func viewLoaded() {
        view?.setupInitialState()
        loadData()
    }

    func eventHandler(_ event: MainViewModelEvent) {
        switch event {
        case .showMoreButtonTapped: showAllFilteredElements()
        case .categoryChanged(let tag): tabSelected(tag)
        case .addToFavoriteButtonTapped(let stock): addOrRemoveFromFavorites(stock)
        case .filteringModeStarted(let filterText): filterStocks(by: filterText)
        case .errorLoadingData: loadData()
        }
    }
}

// MARK: - Supporting methods
private extension MainViewModel {
    func loadData() {
        view?.showLoading()
        Task {
            do {
                try await fetchDataFromServer()
                setFavoritesToFetchedData()
                checkDataAndUpdateView()
            } catch {
                getError()
            }
        }
    }

    func fetchDataFromServer() async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        self.data = try await networkService.fetchDataFromServer()
    }

    func setFavoritesToFetchedData() {
        let favSymbols = Set(favorites.map { $0.symbol })
        self.data = data.map { stock in
            var copy = stock
            copy.isFavorite = favSymbols.contains(stock.symbol)
            return copy
        }
    }


    func checkDataAndUpdateView() {
        isDataValid() ? updateData() : getError()
    }

    func isDataValid() -> Bool {
        return !data.isEmpty
    }

    func updateData(animate: Bool = true) {
        updateFavorites()
        displayData = getCorrectData()
        if isFiltering {
            showFirstFourElements()
        } else {
            updateView(animate: animate)
        }
    }


    func showAllFilteredElements(animate: Bool = true) {
        displayData = getCorrectData()
        updateView()
    }

    func tabSelected(_ index: Int) {
        if index == 0 {
            isFavoritesChosen = false
        } else if index == 1 {
            isFavoritesChosen = true
        }
        updateData()
    }

    func addOrRemoveFromFavorites(_ stock: StockModel) {
        setStockAsFavorite(stock)
        updateData(animate: false)
    }

    func filterStocks(by text: String) {
        if text.isEmpty {
            isFiltering = false
            filterText = ""
        } else {
            isFiltering = true
            filterText = text
        }
        updateData()
    }

    func getFavoritesFromUD() {
        self.favorites = udManager.loadFavoritesFromUD()
    }

    func getCorrectData() -> [StockModel] {
        updateFavorites()
        let base = isFavoritesChosen ? favorites : data

        if filterText.isEmpty {
            return base
        } else {
            return base.filter {
                $0.symbol.lowercased().contains(filterText.lowercased()) ||
                $0.name.lowercased().contains(filterText.lowercased())
            }
        }
    }

    func updateFavorites() {
        favorites =  data.filter { $0.isFavorite }
    }

    func showFirstFourElements(animate: Bool = true) {
        if displayData.count < 4 {
            updateView()
        } else {
            print("Here")
            let first4 = Array(displayData.prefix(4))
            print(first4.count)
            updateView(with: first4)
        }
    }

    func updateView(with data: [StockModel]? = nil, animate: Bool = true) {
        let correctData = data ?? displayData
        view?.configure(with: correctData, isFavoritesChosen, isFiltering, animate: animate)
    }

    func getError() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError()
        }
    }

    func setStockAsFavorite(_ stock: StockModel) {
        if let index = data.firstIndex(of: stock) {
            data[index].isFavorite.toggle()
            saveToUD(stock)
        }
    }

    func saveToUD(_ stock: StockModel) {
        switch !stock.isFavorite {
        case true: udManager.addToFavorites(stock)
        case false: udManager.removeFromFavorites(stock)
        }
    }
}
