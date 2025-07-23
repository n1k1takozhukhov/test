import UIKit

final class AddToFavButton: UIButton {

    var onAddToFavButtonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        setImage(UIImage(named: "starGray"), for: .normal)
        heightAnchor.constraint(equalToConstant: 16).isActive = true
        widthAnchor.constraint(equalToConstant: 16).isActive = true

        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc func buttonTapped() {
        onAddToFavButtonTapped?()
    }
}
