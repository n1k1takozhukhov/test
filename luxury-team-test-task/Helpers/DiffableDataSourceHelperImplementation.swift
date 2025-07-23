import UIKit

final class DiffableDataSourceHelperImplementation<TableSection: Hashable, TableItem: Hashable> {

    // MARK: Properties

    private weak var tableDataSource: UITableViewDiffableDataSource<TableSection, TableItem>?

    // MARK: Initializers

    init(
        tableDataSource: UITableViewDiffableDataSource<TableSection, TableItem>?
    ) {
        self.tableDataSource = tableDataSource
    }

    // MARK: Events

    func getSectionType(for section: Int) -> TableSection? {
        guard
            let snapshot = tableDataSource?.snapshot(),
            section < snapshot.sectionIdentifiers.count else {
            return nil
        }

        return snapshot.sectionIdentifiers[section]
    }

    func getItem(at indexPath: IndexPath) -> TableItem? {
        guard
            let sectionType = getSectionType(for: indexPath.section),
            let snapshot = tableDataSource?.snapshot() else {
            return nil
        }

        let itemsInSection = snapshot.itemIdentifiers(inSection: sectionType)
        guard indexPath.row < itemsInSection.count else { return nil }
        return itemsInSection[indexPath.row]
    }

}
