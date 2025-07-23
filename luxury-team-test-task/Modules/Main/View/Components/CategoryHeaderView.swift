import UIKit
import SnapKit

final class CategoryHeaderView: UIView {

    private lazy var stockButton = AppButton(style: .stocks, isSelected: true)
    private lazy var favoriteButton = AppButton(style: .favourite, isSelected: false)
    private lazy var categoriesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stockButton, favoriteButton, UIView()])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    var tabSelected: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        setupBlending([categoriesStackView])
        addSubview(categoriesStackView)
        categoriesStackView.snp.makeConstraints { $0.edges.equalToSuperview() }

        stockButton.onButtonTapped = { [weak self] tag in
            guard let self = self else { return }
            stockButton.applySelectedStyle(true)
            favoriteButton.applySelectedStyle(false)
            tabSelected?(tag)
        }
        favoriteButton.onButtonTapped = { [weak self] tag in
            guard let self = self else { return }
            stockButton.applySelectedStyle(false)
            favoriteButton.applySelectedStyle(true)
            tabSelected?(tag)
        }
    }

    func setupBlending(_ stacks: [UIStackView]) {
        stacks.forEach {
            $0.backgroundColor = .systemBackground
            $0.isOpaque = true
        }
    }
}
