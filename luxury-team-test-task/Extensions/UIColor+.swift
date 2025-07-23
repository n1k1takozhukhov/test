import UIKit

extension UIColor {

    static func gradientColor(colors: [CGColor], frame: CGRect) -> UIColor {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return .white
        }
        gradientLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let image = image {
            return UIColor(patternImage: image)
        }
        else {
            return .white
        }
    }

}
