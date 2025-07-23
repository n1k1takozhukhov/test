import UIKit

extension UIViewController {

    func animateWithKeyboard(notification: NSNotification, animations: ((_ keyboardFrame: CGRect) -> Void)?) {
        guard
            let userInfo = notification.userInfo,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
            let curve = UIView.AnimationCurve(rawValue: curveValue) else {
            return
        }

        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) {
            animations?(keyboardFrameValue.cgRectValue)
            self.view?.layoutIfNeeded()
        }

        animator.startAnimation()
    }

}
