import UIKit

class CountryTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkbox: UIButton!
    
    // Property to track if the checkbox is checked or not
    var isChecked: Bool = false {
        didSet {
            checkbox.setImage(isChecked ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square"), for: .normal)
        }
    }
    
    // Method to configure the cell with country data and its checked state
    func configure(with country: Country, checked: Bool) {
        nameLabel.text = country.name
        isChecked = checked
    }
}


