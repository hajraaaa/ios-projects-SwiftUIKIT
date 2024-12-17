import UIKit

class CategoryItemCell: UICollectionViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    
    private let defaultTextColor = UIColor(named: "itemText") ?? UIColor.black
    private let defaultBorderColor = UIColor(named: "itemBorder")?.cgColor ?? UIColor.gray.cgColor
    private let selectedTextColor = UIColor(named: "navColor") ?? UIColor.blue
    private let selectedBorderColor = UIColor(named: "navColor")?.cgColor ?? UIColor.blue.cgColor

    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCellStyle()
    }
    
    private func configureCellStyle() {
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1
        self.layer.borderColor = defaultBorderColor
        tagLabel.textColor = defaultTextColor
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                tagLabel.textColor = selectedTextColor
                self.layer.borderColor = selectedBorderColor
            } else {
                tagLabel.textColor = defaultTextColor
                self.layer.borderColor = defaultBorderColor
            }
        }
    }
    
    func setAsSelected(_ selected: Bool) {
            isSelected = selected
            tagLabel.textColor = selected ? selectedTextColor : defaultTextColor
            self.layer.borderColor = selected ? selectedBorderColor : defaultBorderColor
        }
}
