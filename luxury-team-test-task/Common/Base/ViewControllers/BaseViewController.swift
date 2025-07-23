import UIKit

// MARK: - BaseViewController

class BaseViewController: UIViewController {

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.Common.commonWhite.color
        setupSubviews()
        bindViewModel()
    }

    // MARK: Actions

    @objc
    func didTapBackButton() {
        preconditionFailure("This method needs to be overridden by a subclass.")
    }

    // MARK: Events

    func setupSubviews() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }

    func bindViewModel() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }

}
