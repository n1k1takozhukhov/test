import UIKit
import SnapKit

final class CollectionHeaderView: UICollectionReusableView {

    // MARK: - Properties
    static let reuseIdentifier = "CollectionHeaderView"
    private let label: UILabel = {
        let label = AppLabel(type: .searchHeader)
        label.font = AppConstants.Fonts.regular
        label.textColor = AppConstants.Colors.black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Public methods
    func configure(text: String) {
        label.text = text
    }

    private func setupUI() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}
