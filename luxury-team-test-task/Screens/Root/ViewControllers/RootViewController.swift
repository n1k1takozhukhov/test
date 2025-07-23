import UIKit

import SnapKit

final class RootViewController: UIViewController {

    // MARK: Properties

    var viewModel: RootViewModelProtocol?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel?.start()
    }

    // MARK: Private

    private func setup() {}

}
