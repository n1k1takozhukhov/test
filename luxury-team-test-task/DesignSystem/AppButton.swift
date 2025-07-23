import UIKit

enum AppButtonStyle {
    case stocks
    case favourite
    case textFieldClear
    case showMore
}

final class AppButton: UIButton {

    var onButtonTapped: ((Int) -> Void)?
    var onClearTextButtonTapped: (() -> Void)?
    var onShowMoreButtonTapped: (() -> Void)?

    init(style: AppButtonStyle, isSelected: Bool) {
        super.init(frame: .zero)
        configure(style, isSelected)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applySelectedStyle(_ isSelected: Bool) {
        if isSelected {
            setTitleColor(.black, for: .normal)
            titleLabel?.font = AppConstants.Fonts.headline
        } else {
            setTitleColor(AppConstants.Colors.gray, for: .normal)
            titleLabel?.font = AppConstants.Fonts.regular
        }
    }
}

private extension AppButton {
    func configure(_ style: AppButtonStyle, _ isSelected: Bool) {
        switch style {
        case .stocks:
            tag = 0
            setTitle("Stocks", for: .normal)
            setTitleColor(.black, for: .normal)
            titleLabel?.font = AppConstants.Fonts.headline
            applySelectedStyle(isSelected)
            addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        case .favourite:
            tag = 1
            setTitle("Favorites", for: .normal)
            setTitleColor(.black, for: .normal)
            titleLabel?.font = AppConstants.Fonts.headline
            applySelectedStyle(isSelected)
            addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        case .textFieldClear:
            setImage(UIImage(named: "clearText"), for: .normal)
            addTarget(self, action: #selector(clearTextButtonTapped), for: .touchUpInside)
            translatesAutoresizingMaskIntoConstraints = false
            heightAnchor.constraint(equalToConstant: 24).isActive = true
            widthAnchor.constraint(equalToConstant: 24).isActive = true
        case .showMore:
            setTitle("Show more", for: .normal)
            setTitleColor(.black, for: .normal)
            titleLabel?.font = AppConstants.Fonts.searchPlaceholder
            addTarget(self, action: #selector(showMoreButtonTapped), for: .touchUpInside)
        }
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        onButtonTapped?(sender.tag)
    }

    @objc private func clearTextButtonTapped() {
        onClearTextButtonTapped?()
    }

    @objc private func showMoreButtonTapped() {
        onShowMoreButtonTapped?()
    }
}
