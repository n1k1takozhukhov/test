import UIKit
import SnapKit

final class SearchCell: UICollectionViewCell {

    private lazy var label: UILabel = {
        let label = AppLabel(type: .searchRequest)
        label.font = AppConstants.Fonts.searchPlaceholder
        label.textColor = AppConstants.Colors.black
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    var onLabelTapped: ((String) -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with text: String) {
        label.text = text
    }

    private func setupUI() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = AppConstants.Colors.brightGray
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(ButtonTapped))
        addGestureRecognizer(tap)
    }

    @objc private func ButtonTapped() {
        let stockName = label.text ?? ""
        onLabelTapped?(stockName)
    }
}
