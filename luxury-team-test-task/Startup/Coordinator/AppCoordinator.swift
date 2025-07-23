import UIKit

// MARK: - Coordinator

final class AppCoordinator: Coordinator {

    // MARK: Properties

    let window: UIWindow?
    lazy var rootCoordinator = RootCoordinator(window: window)

    // MARK: Initializers

    init(window: UIWindow?) {
        self.window = window
    }

    // MARK: Coordinator

    override func start() {
        guard let window = window else { return }

        showRootInterface()
        window.makeKeyAndVisible()
        LogsService.info("")
    }

    override func finish() {
        removeAllChildCoordinators()
        LogsService.info("")
    }

}

// MARK: - Routing

extension AppCoordinator {

    func showRootInterface() {
        addChildCoordinator(rootCoordinator)
        rootCoordinator.delegate = self
        rootCoordinator.start()
    }

}

// MARK: - RootCoordinatorDelegate

extension AppCoordinator: RootCoordinatorDelegate {

    func didFinish(from coordinator: RootCoordinator) {
        removeChildCoordinator(coordinator)
    }

}
