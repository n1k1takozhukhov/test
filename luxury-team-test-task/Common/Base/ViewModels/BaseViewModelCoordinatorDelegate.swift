import UIKit

protocol BaseViewModelCoordinatorDelegate: AnyObject {

    func showAlert(with viewData: AlertViewData, from controller: UIViewController)
    func showAlertController(
        title: String?,
        items: [(title: String, action: (() -> Void))],
        from controller: UIViewController
    )
    func showLoader(in viewController: UIViewController)
    func hideLoader()
    func close(from controller: UIViewController, finish: Bool, _ completion: (() -> Void)?)

}

extension BaseViewModelCoordinatorDelegate {

    func close(from controller: UIViewController, finish: Bool = false, _ completion: (() -> Void)? = nil) {
        close(from: controller, finish: finish, completion)
    }

}
