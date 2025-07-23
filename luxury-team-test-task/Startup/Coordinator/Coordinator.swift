import UIKit

// MARK: - Coordinator

class Coordinator {

    // MARK: Properties

    private(set) var childCoordinators: [Coordinator] = []
    private var loaderView: UIView?

    // MARK: Lifecycle

    deinit {
        removeAllChildCoordinators()
    }

    // MARK: Public

    func start() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }

    func finish() {
        preconditionFailure("This method needs to be overriden by concrete subclass.")
    }

    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(of: coordinator) {
            childCoordinators.remove(at: index)
        }
        else {
            print("Couldn't remove coordinator: \(coordinator). It's not a child coordinator.")
        }
    }

    func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        childCoordinators = childCoordinators.filter {
            $0 is T == false
        }
    }

    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }

    func hasCoordinatorAlreadyAdded<T>(type: T.Type) -> Bool {
        !childCoordinators.filter { $0 is T }.isEmpty
    }

    func showAlert(with viewData: AlertViewData, from controller: UIViewController) {
        let alertController = UIAlertController(title: viewData.title, message: viewData.text, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: viewData.closeButtonTitle, style: .cancel) { _ in
            viewData.close?()
        })

        if let actionButtonTitle = viewData.actionButtonTitle {
            let preferredAlertAction = UIAlertAction(title: actionButtonTitle, style: viewData.actionStyle) { _ in
                viewData.action?()
            }

            alertController.addAction(preferredAlertAction)
            alertController.preferredAction = preferredAlertAction
        }

        controller.present(alertController, animated: true)
    }

    func showAlertController(
        title: String?,
        items: [(title: String, action: (() -> Void))],
        from controller: UIViewController
    ) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)

        for item in items {
            let action = UIAlertAction(title: item.title, style: .default) { _ in
                item.action()
            }
            action.setValue(Colors.Status.statusRed.color, forKey: "titleTextColor")
            alertController.addAction(action)
        }

        let cancelAction = UIAlertAction(title: Strings.Common.Button.Cancel.title, style: .cancel, handler: nil)
        cancelAction.setValue(Colors.Status.statusRed.color, forKey: "titleTextColor")
        alertController.addAction(cancelAction)

        controller.present(alertController, animated: true, completion: nil)
    }

    func showLoader(in viewController: UIViewController) {
        guard loaderView == nil else { return }

        let overlay = UIView()
        overlay.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()

        overlay.addSubview(activityIndicator)
        viewController.view.addSubview(overlay)

        overlay.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        loaderView = overlay
    }

    func hideLoader() {
        loaderView?.removeFromSuperview()
        loaderView = nil
    }

    func close(from controller: UIViewController, finish: Bool = false, _ completion: (() -> Void)? = nil) {
        if let navigationController = controller.navigationController, navigationController.viewControllers.count > 1 {
            let _ = navigationController.popViewController(animated: true) {
                if finish {
                    self.finish()
                }
                completion?()
            }
        }
        else {
            controller.dismiss(animated: true) {
                if finish {
                    self.finish()
                }
                completion?()
            }
        }
    }

}

// MARK: - Equatable

extension Coordinator: Equatable {

    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        lhs === rhs
    }

}

extension Coordinator {

    subscript<T>(type: T.Type) -> T? {
        childCoordinators.filter { $0 is T }.first as? T
    }

}
