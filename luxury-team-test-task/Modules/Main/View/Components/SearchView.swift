import UIKit
import SnapKit

final class SearchView: UIView {

    // MARK: - Properties
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "glass"), for: .normal)
        button.tintColor = AppConstants.Colors.black
        button.backgroundColor = .clear
        return button
    }()
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = AppConstants.Fonts.searchBar
        textField.textColor = AppConstants.Colors.black
        textField.backgroundColor = .systemBackground
        textField.returnKeyType = .search
        let placeholderText = "Find company or ticker"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: AppConstants.Colors.black,
            .font: AppConstants.Fonts.searchBar ?? .systemFont(ofSize: 16)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        return textField
    }()
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "clearText"), for: .normal)
        button.tintColor = AppConstants.Colors.black
        button.backgroundColor = .clear
        button.isHidden = true
        return button
    }()

    var onTextChanged: ((String) -> Void)?
    var onBeginEditing: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 24
        layer.borderColor = AppConstants.Colors.black.cgColor
        layer.borderWidth = 1

        addSubview(leftButton)
        addSubview(textField)
        addSubview(rightButton)

        leftButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        textField.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(leftButton.snp.trailing).inset(-8)
            $0.trailing.equalTo(rightButton.snp.leading).inset(-8)
        }
        rightButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }

    private func setupActions() {
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.delegate = self
        rightButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        rightButton.isHidden = text.isEmpty
        onTextChanged?(text)
    }

    @objc private func clearTextField() {
        textField.text = ""
        rightButton.isHidden = true
        onTextChanged?("")
    }

    @objc private func leftButtonTapped() {
        // Можно добавить кастомное действие, если нужно
    }
}

extension SearchView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        onBeginEditing?()
    }
}
