import UIKit

import SnapKit

final class ListViewController: BaseViewController {

    // MARK: Properties

    typealias TableDataSource = UITableViewDiffableDataSource<ListTableSection, ListTableItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ListTableSection, ListTableItem>

    var viewModel: ListViewModelProtocol?
    private lazy var searchBar: SearchBarView = {
        let view = SearchBarView()
        view.delegate = self
        return view
    }()
    private lazy var filterTabView: ListFilterTabsView = {
        let view = ListFilterTabsView()
        view.delegate = self
        return view
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(cellType: SymbolTableViewCell.self)
        tableView.register(cellType: CollectionTableViewCell.self)
        return tableView
    }()
    private var searchBarHeightConstraint: Constraint?
    private var filterTopConstraint: Constraint?
    private var isSearchBarHidden = false

    private lazy var dataSource = makeDataSource()
    private lazy var dataSourceHelper = DiffableDataSourceHelperImplementation<
        ListTableSection,
        ListTableItem
    >(
        tableDataSource: dataSource
    )
    private lazy var cellFactory: ListTableCellFactory = ListTableCellFactoryImplementation(tableView: tableView)

    private enum Constants {
        enum Height {
            enum Header {
                static let titled: CGFloat = 35
            }
            enum Cell {
                static let symbol: CGFloat = 76
                static let collection: CGFloat = 48
            }
        }
    }

    // MARK: BaseViewController

    override func setupSubviews() {
        view.addSubviews(
            searchBar,
            filterTabView,
            tableView
        )

        searchBar.snp.makeConstraints {
            searchBarHeightConstraint = $0.height.equalTo(48).constraint
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        filterTabView.snp.makeConstraints {
            $0.height.equalTo(32)
            filterTopConstraint = $0.top.equalTo(searchBar.snp.bottom).offset(20).constraint
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        updateTableViewConstraints()
    }

    override func bindViewModel() {
        viewModel?.reloadItems = { [weak self] sections, items in
            guard let self else { return }
            applySnapshot(
                sections: sections,
                items: items,
                animatingDifferences: false
            )
        }
        viewModel?.updateFilterVisibility = { [weak self] isVisible in
            guard let self else { return }
            DispatchQueue.main.async {
                self.filterTabView.isHidden = !isVisible
                self.updateTableViewConstraints()
            }
        }

        viewModel?.start(in: self)
    }

    private func updateTableViewConstraints() {
        if filterTabView.isHidden {
            tableView.snp.makeConstraints {
                $0.top.equalTo(searchBar.snp.bottom).inset(-4)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
        else {
            tableView.snp.remakeConstraints {
                $0.top.equalTo(filterTabView.snp.bottom).inset(-4)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }

        view.layoutIfNeeded()
    }

}

// MARK: - Data source

extension ListViewController {

    private func makeDataSource() -> TableDataSource {
        TableDataSource(tableView: tableView) { [weak self] _, indexPath, item -> UITableViewCell? in
            guard let self else { return nil }
            switch item {
            case .symbol(let viewData):
                return cellFactory.createSymbolCell(at: indexPath, viewData: viewData)
            case .cellectionRow(let viewData):
                return cellFactory.createCollectionCell(at: indexPath, viewData: viewData)
            }
        }
    }

    private func applySnapshot(
        sections: [ListTableSection],
        items: [ListTableItem],
        animatingDifferences: Bool = true
    ) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        append(items, to: &snapshot)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences) { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    private func append(_ items: [ListTableItem], to snapshot: inout Snapshot) {
        let containsSymbolTableItem = items.contains {
            if case .symbol = $0 {
                return true
            }
            return false
        }

        if containsSymbolTableItem {
            snapshot.appendItems(items, toSection: .main)
        }
        else {
            items.forEach {
                if case let .cellectionRow(viewData) = $0 {
                    snapshot.appendItems([$0], toSection: viewData.section)
                }
            }
        }
    }

}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {

    /// Headers
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionType = dataSourceHelper.getSectionType(for: section) else { return .zero }
        return shouldShowHeader(for: sectionType) ? Constants.Height.Header.titled : .zero
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let sectionType = dataSourceHelper.getSectionType(for: section),
            shouldShowHeader(for: sectionType) else {
            return nil
        }

        switch sectionType {
        case .main:
            return ListTableTitleHeaderView(
                title: Strings.List.Search.Section.title,
                rightButtonTitle: Strings.List.Search.Section.more
            )
        case .popular:
            return ListTableTitleHeaderView(title: Strings.List.Search.Empty.Section.popular)
        case .searched:
            return ListTableTitleHeaderView(title: Strings.List.Search.Empty.Section.searched)
        }
    }

    /// Cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSourceHelper.getItem(at: indexPath) {
        case .symbol:
            return Constants.Height.Cell.symbol
        case .cellectionRow:
            return Constants.Height.Cell.collection
        case .none:
            return .zero
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case .symbol = dataSourceHelper.getItem(at: indexPath) else { return }
        viewModel?.didTapItem(at: indexPath.row)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let firstIndexPath = tableView.indexPathsForVisibleRows?.first else { return }

        let cellRect = tableView.rectForRow(at: firstIndexPath)
        let cellFrameInView = tableView.convert(cellRect, to: view)
        let filterBottomY = filterTabView.frame.maxY

        let minY = cellFrameInView.minY
        let threshold: CGFloat = 12

        if !isSearchBarHidden, minY < filterBottomY - threshold {
            toggleSearchBar(hidden: true)
        }
        else if isSearchBarHidden, minY > filterBottomY + threshold {
            toggleSearchBar(hidden: false)
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

    // MARK: Helpers

    private func shouldShowHeader(for section: ListTableSection) -> Bool {
        switch section {
        case .main:
            guard
                let viewModel,
                let query = viewModel.searchQuery,
                !query.isEmpty else {
                return false
            }
            return true
        default:
            return true
        }
    }

    private func toggleSearchBar(hidden: Bool) {
        isSearchBarHidden = hidden
        searchBarHeightConstraint?.update(offset: hidden ? 0 : 48)
        filterTopConstraint?.update(offset: hidden ? 0 : 20)
        searchBar.alpha = hidden ? 0 : 1

        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

}

// MARK: - SearchTextFieldDelegate, ListFilterDelegate

extension ListViewController: SearchTextFieldDelegate, ListFilterDelegate {

    func searchField(didChange text: String?) {
        viewModel?.searchQuery = text
    }

    func searchFieldDidTapClearButton() {
        viewModel?.searchQuery = nil
    }

    func listFilter(didChange filter: ListFilter) {
        viewModel?.didChangeFilter(type: filter)
        scrollTableToTop()
    }

    // MARK: Private

    private func scrollTableToTop() {
        if tableView.numberOfSections > 0, tableView.numberOfRows(inSection: 0) > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            DispatchQueue.main.async {
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }

}
