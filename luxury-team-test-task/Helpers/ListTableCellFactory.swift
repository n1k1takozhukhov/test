import UIKit

protocol ListTableCellFactory: AnyObject {

    func createSymbolCell(at indexPath: IndexPath, viewData: ListItemViewData) -> UITableViewCell
    func createCollectionCell(at indexPath: IndexPath, viewData: CollectionRowViewData) -> UITableViewCell

}

final class ListTableCellFactoryImplementation: ListTableCellFactory {

    // MARK: Properties

    private let tableView: UITableView

    // MARK: Initializers

    init(tableView: UITableView) {
        self.tableView = tableView
    }

    // MARK: ListTableCellFactory

    func createSymbolCell(at indexPath: IndexPath, viewData: ListItemViewData) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SymbolTableViewCell.self)
        cell.bind(viewData: viewData)
        return cell
    }

    func createCollectionCell(at indexPath: IndexPath, viewData: CollectionRowViewData) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CollectionTableViewCell.self)
        cell.bind(viewData: viewData)
        return cell
    }

}
