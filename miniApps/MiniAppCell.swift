import UIKit

class MiniAppCell: UITableViewCell {
    
    private let nameLabel = UILabel()
    private let openButton = UIButton(type: .system)
    private var miniAppView: UIView?
    
    var buttonAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .white
        openButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        contentView.addSubview(openButton)
        contentView.backgroundColor = .darkGray
        contentView.layer.borderWidth = 3.0
        contentView.layer.borderColor = UIColor.white.cgColor

        openButton.setTitle("Open", for: .normal)
        openButton.setTitleColor(.white, for: .normal)
        openButton.addTarget(self, action: #selector(openButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            openButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            openButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
    }
    
    @objc private func openButtonTapped() {
        buttonAction?()
    }

    func configure(with miniApp: MiniApp, isExpanded: Bool) {
        nameLabel.text = miniApp.name

        miniAppView?.removeFromSuperview()
        
        if isExpanded {
            miniAppView = miniApp.view
            miniAppView?.translatesAutoresizingMaskIntoConstraints = false
            if let miniAppView = miniAppView {
                contentView.addSubview(miniAppView)
                
                NSLayoutConstraint.activate([
                    miniAppView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                    miniAppView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                ])
            }
        }
    }
}
