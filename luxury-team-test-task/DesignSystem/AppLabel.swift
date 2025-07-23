import UIKit

enum AppLabelType {
    case category
    case title
    case subtitle
    case rate
    case rateChange
    case searchHeader
    case searchRequest
}

final class AppLabel: UILabel {

    // MARK: - Init
    init(type: AppLabelType, numberOfLines: Int = 1, title: String? = nil) {
        super.init(frame: .zero)
        configure(type, numberOfLines: numberOfLines, title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension AppLabel {
    func configure(_ type: AppLabelType, numberOfLines: Int, title: String?) {
        switch type {
        case .category:
            font = AppConstants.Fonts.headline
            textColor = AppConstants.Colors.black
            backgroundColor = .systemBackground
            isOpaque = true
        case .title:
            font = AppConstants.Fonts.regular
            textColor = AppConstants.Colors.black
        case .subtitle:
            font = AppConstants.Fonts.body
            textColor = AppConstants.Colors.black
            self.numberOfLines = numberOfLines
        case .rate:
            font = AppConstants.Fonts.regular
            textColor = AppConstants.Colors.black
        case .rateChange:
            font = AppConstants.Fonts.body
            textColor = AppConstants.Colors.black
            textAlignment = .right
        case .searchRequest:
            font = AppConstants.Fonts.searchPlaceholder
            textColor = AppConstants.Colors.black
        case .searchHeader:
            textColor = AppConstants.Colors.black
            font = AppConstants.Fonts.regular
        }
        self.text = title
        self.numberOfLines = numberOfLines
    }
}
