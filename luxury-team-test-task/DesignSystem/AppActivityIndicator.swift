import UIKit

final class AppActivityIndicator: UIActivityIndicatorView {

    override init(style: UIActivityIndicatorView.Style = .large) {
        super.init(style: style)
        color = AppConstants.Colors.green
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
