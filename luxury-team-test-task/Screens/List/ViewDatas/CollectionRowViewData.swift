import Foundation

enum CollectionViewSection: Hashable {

    case main

}

enum CollectionViewItem: Hashable {

    case item(viewData: CollectionItemViewData)

}

struct CollectionItemViewData: Hashable {

    let id: UUID = UUID()
    let title: String

}
