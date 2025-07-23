import UIKit

extension UINavigationController {

    func popViewController(animated: Bool, completion: @escaping () -> Void) {
        popViewController(animated: animated)
        if animated, let coordinator = self.transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        }
        else {
            completion()
        }
    }

}
