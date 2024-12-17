import UIKit
import Kingfisher

class RecipeCardCell: UITableViewCell {
    
    @IBOutlet weak var Ratings: UILabel!
    @IBOutlet weak var ReceipeName: UILabel!
    @IBOutlet weak var Meal: UILabel!
    @IBOutlet weak var ReviewCount: UILabel!
    @IBOutlet weak var Difficulty: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var receipeImagebg: UIImageView!
    @IBOutlet weak var preptime: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var servings: UILabel!
    @IBOutlet weak var cooktime: UILabel!
    @IBOutlet weak var favButton: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        configureCellStyle()
        configureCardViewStyle()
    }
    
    private func configureCellStyle() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    private func configureCardViewStyle() {
        receipeImagebg.clipsToBounds = true
        receipeImagebg.layer.cornerRadius = 10
        receipeImagebg.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        cardView.clipsToBounds = false
        cardView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.09).cgColor
        cardView.layer.shadowOpacity = 1.0
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 10
        
        favButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.09).cgColor
        favButton.layer.shadowOpacity = 1.0
        favButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        favButton.layer.shadowRadius = 10
        
        if let reviewCountLabel = ReviewCount {
            reviewCountLabel.font = UIFont(name: "Satoshi-Bold", size: 20)
            reviewCountLabel.textColor = UIColor(named: "navColor")
            reviewCountLabel.font = UIFont.boldSystemFont(ofSize: 20)
        }
    }
    
    func configure(with recipe: Recipe) {
        ReceipeName.text = recipe.name
        Ratings.text = "Ratings: \(recipe.rating)"
        Meal.text = recipe.mealType.joined(separator: ", ")
        ReviewCount.text = "Review Count: \(recipe.reviewCount)"
        Difficulty.text = recipe.difficulty.rawValue
        
        preptime.text = "\(recipe.prepTimeMinutes) mins prep"
        cooktime.text = "\(recipe.cookTimeMinutes) mins cook"
        calories.text = "\(recipe.caloriesPerServing) cal"
        servings.text = "\(recipe.servings) servings"
            
            loadImage(from: recipe.image)
        }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL string")
            return
        }
        let downsamplingProcessor = DownsamplingImageProcessor(size: receipeImagebg.bounds.size)
        let roundCornerProcessor = RoundCornerImageProcessor(cornerRadius: 20)

        receipeImagebg.kf.setImage(with: url, options: [
            .processor(downsamplingProcessor),
            .processor(roundCornerProcessor),
            .transition(.fade(0.3)),
            .cacheOriginalImage
        ]) { result in
            switch result {
            case .success(let value):
                print("Image loaded successfully: \(value.image)")
            case .failure(let error):
                print("Error loading image: \(error)")
            }
        }
    }
    
}
