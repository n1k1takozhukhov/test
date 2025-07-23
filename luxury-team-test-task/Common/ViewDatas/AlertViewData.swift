import UIKit

struct AlertViewData {

    // MARK: Properties

    var title: String?
    var text: String?
    var actionStyle: UIAlertAction.Style
    var actionButtonTitle: String?
    var closeButtonTitle: String
    var action: (() -> Void)?
    var close: (() -> Void)?

    // MARK: Initializers

    init(
        title: String? = nil,
        text: String? = nil,
        actionStyle: UIAlertAction.Style,
        actionButtonTitle: String? = nil,
        closeButtonTitle: String,
        action: (() -> Void)? = nil,
        close: (() -> Void)? = nil
    ) {
        self.title = title
        self.text = text
        self.actionStyle = actionStyle
        self.actionButtonTitle = actionButtonTitle
        self.closeButtonTitle = closeButtonTitle
        self.action = action
        self.close = close
    }

}
