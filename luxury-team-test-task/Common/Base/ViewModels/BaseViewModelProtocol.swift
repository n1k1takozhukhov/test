import UIKit

protocol BaseViewModelProtocol: AnyObject {

    // MARK: Events

    func start()
    func finish(from viewController: UIViewController)

}
