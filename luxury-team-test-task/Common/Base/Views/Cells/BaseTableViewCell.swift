import UIKit

import Reusable

class BaseTableViewCell: UITableViewCell, Reusable {

    // MARK: Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initilization()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initilization()
    }

    func initilization() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }

}
