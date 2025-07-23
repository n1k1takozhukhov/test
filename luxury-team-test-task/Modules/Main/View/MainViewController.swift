import UIKit
import SnapKit

protocol MainViewInterface {
    func setupInitialState()
    func showLoading()
    func configure(with data: [StockModel], _ isFavoritesChosen: Bool, _ isFilteringMode: Bool, animate: Bool)
    func showError()
}

final class MainViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var searchBar = SearchView()
    private lazy var categoryHeader = CategoryHeaderView()

    private lazy var searchHeaderView = SearchHeaderView()

    private lazy var contentTableView = StocksTableView()
    private lazy var searchPlaceholderCollectionView = SearchCollectionView()
    private lazy var activityIndicator = AppActivityIndicator()

    private lazy var headerAndTableViewStack = AppStackView([ categoryHeader, contentTableView], axis: .vertical)

    private lazy var contentStack = AppStackView([searchBar, headerAndTableViewStack], axis: .vertical, spacing: 20)


    let viewModel: MainViewModelling

    // MARK: - Init
    init(viewModel: MainViewModelling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewLoaded()
        setupUI()
    }
}

// MARK: - MainViewInterface
extension MainViewController: MainViewInterface {
    func setupInitialState() {
        setupUI()
        setupAction()
    }

    func showLoading() {
        activityIndicator.startAnimating()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isHideContent(true)
        }
    }

    func configure(with data: [StockModel], _ isFavoritesChosen: Bool, _ isFilteringMode: Bool, animate: Bool = true) {

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isHideContent(false)
            activityIndicator.stopAnimating()
        }

        updateUI(with: data, isFavoritesChosen: isFavoritesChosen, isFilteringMode: isFilteringMode, animate: animate)
    }

    func showError() {
        activityIndicator.stopAnimating()
        isHideContent(true)
        showAlert()
    }
}

// MARK: - Setup UI
private extension MainViewController {
    func setupUI() {
        view.backgroundColor = .red // DEBUG: Явный фон для проверки отображения
        view.isOpaque = true

        view.addSubview(searchBar)
        view.addSubview(categoryHeader)
        view.addSubview(contentTableView)

        searchBar.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        categoryHeader.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        contentTableView.snp.makeConstraints {
            $0.top.equalTo(categoryHeader.snp.bottom).inset(-4)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    func configureContentStack() {
        view.addSubviews(contentStack)
        contentStack.setConstraints(isSafeArea: true, allInsets: 16)
    }

    func setupSearchPlaceholder() {
        view.addSubviews(searchPlaceholderCollectionView)
        searchPlaceholderCollectionView.alpha = 0

        NSLayoutConstraint.activate([
            searchPlaceholderCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 32),
            searchPlaceholderCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchPlaceholderCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchPlaceholderCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func configureActivityIndicator() {
        view.addSubviews(activityIndicator)
        setupActivityIndicatorLayout()
    }

    func setupActivityIndicatorLayout() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Setup actions
private extension MainViewController {
    func setupAction() {
        categoryHeader.tabSelected = { [weak self] tag in
            self?.viewModel.eventHandler(.categoryChanged(tag))
        }

        contentTableView.onAddToFavButtonTapped = { [weak self] stock in
            self?.viewModel.eventHandler(.addToFavoriteButtonTapped(stock))
        }

        contentTableView.onHideSearchBar = { [weak self] bool in
            guard let self else { return }
            UIView.animate(withDuration: 0.3) {
//                self.searchBar.isNeedToHideSearchBar(bool)
                self.contentStack.layoutIfNeeded()
            }
        }

        searchBar.onTextChanged = { [weak self] text in
            guard let self else { return }
            swapHeaders(with: text)
            hideSearchPlaceholder()

            viewModel.eventHandler(.filteringModeStarted(text))
        }

        searchBar.onBeginEditing = { [weak self] in
            guard let self else { return }
            showSearchPlaceholder()
        }

        searchPlaceholderCollectionView.onCellTapped = { [weak self]
            stockName in
            guard let self else { return }
//            searchBar.setQueryText(stockName)

            swapHeaders(with: stockName)
            hideSearchPlaceholder()

            viewModel.eventHandler(.filteringModeStarted(stockName))
        }

        searchHeaderView.onShowMoreButtonTapped = { [weak self] in
            self?.viewModel.eventHandler(.showMoreButtonTapped)
        }
    }

    func swapHeaders(with text: String) {
        if !text.isEmpty {
            swapHeadersToSearching()
        } else {
            swapHeadersToBaseMode()
        }
    }

    func swapHeadersToSearching() {
        guard let index = headerAndTableViewStack.arrangedSubviews.firstIndex(of: self.categoryHeader) else { return }
        headerAndTableViewStack.removeArrangedSubview(categoryHeader)
        categoryHeader.removeFromSuperview()
        headerAndTableViewStack.insertArrangedSubview(self.searchHeaderView, at: index)

        contentStack.spacing = 32
    }

    func swapHeadersToBaseMode() {
        guard let index = headerAndTableViewStack.arrangedSubviews.firstIndex(of: self.searchHeaderView) else { print("stockTitle not found"); return }
        headerAndTableViewStack.removeArrangedSubview(searchHeaderView)
        searchHeaderView.removeFromSuperview()
        headerAndTableViewStack.insertArrangedSubview(self.categoryHeader, at: index)
        contentStack.spacing = 20
    }

    func showSearchPlaceholder() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            searchPlaceholderCollectionView.alpha = 1
            [categoryHeader, contentTableView].forEach { $0.alpha = 0 }
        }
    }

    func hideSearchPlaceholder() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            searchPlaceholderCollectionView.alpha = 0
            [categoryHeader, contentTableView].forEach { $0.alpha = 1 }
        }
    }

    func isHideContent(_ isHide: Bool) {
        contentStack.alpha = isHide ? 0 : 1
    }

    func updateUI(with data: [StockModel], isFavoritesChosen: Bool, isFilteringMode: Bool, animate: Bool) {
        contentTableView.updateUI(with: data, isFavoriteChosen: isFavoritesChosen, isFilteringMode: isFilteringMode, animate: animate)
    }

    func showAlert() {
        let alert = AppAlert.create { [weak self] in
            guard let self else { return }
            viewModel.eventHandler(.errorLoadingData)
        }

        present(alert, animated: true)
    }
}

// MARK: - Hide keyboard
private extension MainViewController {
    func setupDismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
