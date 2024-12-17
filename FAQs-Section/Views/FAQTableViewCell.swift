import UIKit

class FAQTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with faq: FAQ) {
        questionLabel.text = faq.question
        answerLabel.text = faq.answer
        answerLabel.isHidden = !faq.isExpanded
    }
}
