import UIKit
import SDWebImage
import SnapKit

final class StocksTableViewCell: UITableViewCell {

    // MARK: - UI Properties
    private lazy var logoImageView: UIImageView = {
        let imageView = AppImageView(type: .stackLogo)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = AppConstants.Colors.gray.withAlphaComponent(0.3)
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var titleLabel = AppLabel(type: .title)
    private lazy var subTitleLabel = AppLabel(type: .subtitle)
    private lazy var addToFavoriteButton = AddToFavButton()
    private lazy var rateLabel = AppLabel(type: .rate)
    private lazy var rateChangeLabel = AppLabel(type: .rateChange)
    private lazy var isFavoriteTextStack = AppStackView([titleLabel, addToFavoriteButton, UIView()], axis: .horizontal, spacing: 6)
    private lazy var textStack = AppStackView([isFavoriteTextStack, subTitleLabel], axis: .vertical, spacing: 5, alignment: .leading)
    private lazy var rateStack = AppStackView([rateLabel, rateChangeLabel], axis: .vertical, alignment: .trailing)
    private lazy var contentStack = AppStackView([logoImageView, textStack, rateStack], axis: .horizontal, spacing: 12, alignment: .center, distribution: .fill)
    private lazy var cellContainer: UIView = {
        let view = UIView()
        view.backgroundColor = AppConstants.Colors.gray
        view.layer.cornerRadius = AppConstants.CornerRadius.medium16
        view.clipsToBounds = true
        return view
    }()

    var onAddToFavButtonTapped: (() -> Void)?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension StocksTableViewCell {
    func configureCell(with stock: StockModel, isGray: Bool) {
        logoImageView.sd_setImage(with: URL(string: stock.logo))
        titleLabel.text = stock.symbol
        subTitleLabel.text = stock.name
        updateFavoriteButtonImage(stock)
        rateLabel.text = "$\(stock.price.cleanString)"
        updateChangeStockPrice(with: stock)
        cellContainer.backgroundColor = isGray ? AppConstants.Colors.brightGray : .clear
    }
}

// MARK: - Configure cell
private extension StocksTableViewCell {
    func setupCell() {
        contentView.addSubview(cellContainer)
        cellContainer.addSubview(logoImageView)
        cellContainer.addSubview(titleLabel)
        cellContainer.addSubview(addToFavoriteButton)
        cellContainer.addSubview(subTitleLabel)
        cellContainer.addSubview(rateLabel)
        cellContainer.addSubview(rateChangeLabel)

        cellContainer.snp.makeConstraints {
            $0.height.equalTo(68)
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(52)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
        }
        rateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.trailing.equalToSuperview().inset(17)
        }
        rateChangeLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(14)
            $0.trailing.equalToSuperview().inset(17)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalTo(logoImageView.snp.trailing).offset(12)
        }
        addToFavoriteButton.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(6)
            $0.centerY.equalTo(titleLabel)
            $0.size.equalTo(16)
            $0.trailing.lessThanOrEqualTo(rateLabel.snp.leading).offset(-8)
        }
        subTitleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(14)
            $0.leading.equalTo(logoImageView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualTo(rateChangeLabel.snp.leading).offset(-8)
        }
    }
}

// MARK: - Setup Action
private extension StocksTableViewCell {
    func setupAction() {
        addToFavoriteButton.onAddToFavButtonTapped = { [weak self] in
            self?.onAddToFavButtonTapped?()
        }
    }
}

// MARK: - Private methods
private extension StocksTableViewCell {
    func updateFavoriteButtonImage(_ stock: StockModel) {
        let image = stock.isFavorite ? "starGold" : "starGray"
        addToFavoriteButton.setImage(UIImage(named: image), for: .normal)
    }

    func updateChangeStockPrice(with stock: StockModel) {
        let changeText = "$\(abs(stock.change)) (\(abs(stock.changePercent))%)"

        if stock.change > 0 {
            rateChangeLabel.textColor = AppConstants.Colors.green
            rateChangeLabel.text = "+\(changeText)"
        } else {
            rateChangeLabel.textColor = AppConstants.Colors.red
            rateChangeLabel.text = "-\(changeText)"
        }
    }
}
