import UIKit

final class SearchHeaderView: UIView {

    // MARK: - Properties
    private lazy var stockTitle = AppLabel(type: .title, title: "Stocks")
    private lazy var showMoreButton = AppButton(style: .showMore, isSelected: false)

    private lazy var contentStack = AppStackView([stockTitle, showMoreButton], axis: .horizontal)

    var onShowMoreButtonTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubviews(contentStack)
        contentStack.setConstraints()
    }

    private func setupAction() {
        showMoreButton.onShowMoreButtonTapped = { [weak self] in
            guard let self else { return }
            onShowMoreButtonTapped?()
        }
    }
}
