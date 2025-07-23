import UIKit

class BaseViewModel: BaseViewModelProtocol {

    // MARK: Events

    func start() {}

    func finish(from viewController: UIViewController) {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }

    func showLoader(
        in viewController: UIViewController?,
        coordinatorDelegate: BaseViewModelCoordinatorDelegate?
    ) {
        guard let viewController else { return }
        coordinatorDelegate?.showLoader(in: viewController)
    }

    func showErrorAlert(
        _ message: String,
        in viewController: UIViewController?,
        coordinatorDelegate: BaseViewModelCoordinatorDelegate?
    ) {
        guard let viewController else { return }
        let alertViewData = AlertViewData(
            title: Strings.Common.Alert.Error.title,
            text: message,
            actionStyle: .default,
            closeButtonTitle: Strings.Common.Button.Close.title
        )
        coordinatorDelegate?.showAlert(with: alertViewData, from: viewController)
    }

}
