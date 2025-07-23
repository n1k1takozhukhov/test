import UIKit

enum AppImageViewType {
    case glass
    case arrow
    case stackLogo
}

final class AppImageView: UIImageView {

    // MARK: - Init
    init(type: AppImageViewType) {
        super.init(frame: .zero)
        configure(type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension AppImageView {
    func configure(_ type: AppImageViewType) {
        switch type {
        case .glass:
            image = UIImage(named: "glass")
            translatesAutoresizingMaskIntoConstraints = false
            heightAnchor.constraint(equalToConstant: 16).isActive = true
            widthAnchor.constraint(equalToConstant: 16).isActive = true
            backgroundColor = .clear
        case .arrow:
            image = UIImage(named: "leftArrow")
            translatesAutoresizingMaskIntoConstraints = false
            heightAnchor.constraint(equalToConstant: 16).isActive = true
            widthAnchor.constraint(equalToConstant: 16).isActive = true
        case .stackLogo:
            contentMode = .scaleAspectFit
            translatesAutoresizingMaskIntoConstraints = false
            heightAnchor.constraint(equalToConstant: 52).isActive = true
            widthAnchor.constraint(equalToConstant: 52).isActive = true
            layer.cornerRadius = AppConstants.CornerRadius.medium16
            clipsToBounds = true
        }
//        self.numberOfLines = numberOfLines
    }
}
