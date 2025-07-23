import UIKit

protocol ListCoordinatorDelegate: AnyObject {

    func didFinish(from coordinator: ListCoordinator)

}

final class ListCoordinator: Coordinator {

    // MARK: Properties

    weak var delegate: ListCoordinatorDelegate?
    private let rootViewController: UIViewController
    private lazy var listViewController: UIViewController = {
        let viewModel = ListViewModel()
        viewModel.coordinatorDelegate = self
        let viewController = ListViewController()
        viewController.viewModel = viewModel
        return viewController
    }()

    // MARK: Initializers

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    // MARK: Coordinator

    override func start() {
        rootViewController.addChild(listViewController)
        rootViewController.view.addSubview(listViewController.view)
        listViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        listViewController.didMove(toParent: rootViewController)

        LogsService.info("")
    }

    override func finish() {
        delegate?.didFinish(from: self)
        LogsService.info("")
    }

}

// MARK: - ListViewModelCoordinatorDelegate

extension ListCoordinator: ListViewModelCoordinatorDelegate {}
