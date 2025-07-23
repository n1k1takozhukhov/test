import UIKit
import SnapKit

enum CollectionSection: Int, CaseIterable {
    case popular, history

    var title: String {
        switch self {
        case .popular: return "Popular requests"
        case .history: return "You’ve searched for this"
        }
    }

    var items: [String] {
        switch self {
        case .popular: ["Apple","Amazon","Google","Tesla","Microsoft"]
        case .history: ["Nvidia","Nokia","Yandex","GM","Microsoft"]
        }
    }
}

final class SearchCollectionView: UICollectionView {

    var onCellTapped: ((String) -> Void)?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = Self.setupUICollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        setupUI()
    }

    private static func setupUICollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 28, right: 0)
        return layout
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        dataSource = self
        delegate = self
        showsHorizontalScrollIndicator = false
        alwaysBounceHorizontal = true
        isScrollEnabled = true
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        registerCell(SearchCell.self)
        registerSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                  viewClass: CollectionHeaderView.self
        )
    }

    private func setupAction() {

    }
}

// MARK: - UICollectionViewDataSource
extension SearchCollectionView: UICollectionViewDataSource {
    func numberOfSections(in cv: UICollectionView) -> Int { CollectionSection.allCases.count
    }

    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: CollectionSection.popular.items.count
        case 1: CollectionSection.history.items.count
        default: 5
        }
    }

    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SearchCell = cv.dequeueCell(for: indexPath)

        let text = switch indexPath.section {
        case 0: CollectionSection.popular.items[indexPath.item]
        case 1: CollectionSection.history.items[indexPath.item]
        default: ""
        }

        cell.configure(with: text)

        cell.onLabelTapped = { [weak self] stockName in
            guard let self else { return }
            onCellTapped?(stockName)
        }

        return cell
    }

    // Для заголовков:
    func collectionView(_ cv: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeaderView", for: indexPath) as! CollectionHeaderView
        let title = CollectionSection(rawValue: indexPath.section)?.title ?? ""
        header.configure(text: title)
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
}
