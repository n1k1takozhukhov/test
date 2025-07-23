import UIKit

struct OptionItemViewData: Hashable {

    let title: String
    let value: String

    init(
        title: String,
        value: String
    ) {
        self.title = title
        self.value = value
    }

}
