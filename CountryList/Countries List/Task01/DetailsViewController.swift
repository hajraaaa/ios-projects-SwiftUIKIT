import UIKit

//Display details of selected countries
class DetailsViewController: UIViewController {
    var countries: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print("selected countries: \(countries)")
    }

}
