import UIKit

// MARK: - RootCoordinatorDelegate

protocol RootCoordinatorDelegate: AnyObject {

    func didFinish(from coordinator: RootCoordinator)

}

// MARK: - Coordinator

final class RootCoordinator: Coordinator {

    // MARK: Properties

    weak var delegate: RootCoordinatorDelegate?
    private let window: UIWindow?
    private lazy var rootViewController: RootViewController = {
        let viewModel = RootViewModel()
        viewModel.coordinatorDelegate = self
        let controller = RootViewController()
        controller.viewModel = viewModel
        return controller
    }()

    // MARK: Initialization

    init(window: UIWindow?) {
        self.window = window
    }

    // MARK: Coordinator

    override func start() {
        LogsService.info("")
        if let rootController = window?.rootViewController {
            rootController.dismiss(animated: false, completion: nil)
            rootController.willMove(toParent: nil)
            rootController.view.removeFromSuperview()
            rootController.removeFromParent()
        }
        window?.rootViewController = rootViewController
    }

    override func finish() {
        delegate?.didFinish(from: self)
        LogsService.info("")
    }

}

// MARK: - RootViewModelCoordinatorDelegate

extension RootCoordinator: RootViewModelCoordinatorDelegate {

    func startMainFlow() {
        let listCoordinator = ListCoordinator(rootViewController: rootViewController)
        listCoordinator.delegate = self
        addChildCoordinator(listCoordinator)
        listCoordinator.start()
    }

}

// MARK: - ListCoordinatorDelegate

extension RootCoordinator: ListCoordinatorDelegate {

    func didFinish(from coordinator: ListCoordinator) {
        removeChildCoordinator(coordinator)
    }

}
