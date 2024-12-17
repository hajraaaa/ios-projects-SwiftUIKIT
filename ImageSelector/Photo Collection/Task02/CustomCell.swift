import UIKit

protocol CustomCellDelegate: AnyObject {
    func didTapPlusButton(in cell: CustomCell)
}

class CustomCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        let titleText = "Add Image\n+"
        let attributedTitle = NSMutableAttributedString(string: titleText)
        
        attributedTitle.addAttribute(.font, value: UIFont.systemFont(ofSize: 20), range: NSRange(location: 0, length: 9))
        attributedTitle.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 9))
        
        attributedTitle.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 10, length: 1))
        attributedTitle.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 10, length: 1))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        return button
    }()
    
    weak var delegate: CustomCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(plusButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            plusButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            plusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        plusButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        delegate?.didTapPlusButton(in: self)
    }
}
