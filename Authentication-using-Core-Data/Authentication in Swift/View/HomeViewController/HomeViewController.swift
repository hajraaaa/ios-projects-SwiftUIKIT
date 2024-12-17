import UIKit
import CoreData

class HomeViewController: UIViewController {

    var userName: String?
    var userImage: UIImage?
    var userCity: String?
    var userEmail: String?

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userCityLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!

    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
        setUserDetails()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUpdatedUserDetails()
    }

    // MARK: - UI Setup
    func setUserDetails() {
        userNameLabel.text = userName ?? "Unknown"
        userEmailLabel.text = userEmail ?? "Unknown"
        userCityLabel.text = userCity ?? "Unknown"
        userProfileImageView.image = userImage ?? UIImage(named: "placeholder-image")
    }

    // MARK: - Fetch Updated User Details
    private func fetchUpdatedUserDetails() {
        guard let email = userEmail else {
            print("Error: No email found")
            return
        }

        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                updateUI(with: user)
            } else {
                print("Error: No user found with this email")
                showAlert(message: "User not found")
            }
        } catch {
            print("Error fetching user: \(error)")
            showAlert(message: "An error occurred while fetching user details")
        }
    }

    // MARK: - Update UI with Fetched User Data
    private func updateUI(with user: Users) {
        userNameLabel.text = user.name ?? "Unknown"
        userEmailLabel.text = user.email ?? "Unknown"
        userCityLabel.text = user.city ?? "Unknown"
        if let imageData = user.profileimage {
            userProfileImageView.image = UIImage(data: imageData)
        } else {
            userProfileImageView.image = UIImage(named: "placeholder-image")
        }
    }

    // MARK: - Logout Functionality
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        logoutUser()
    }

    func logoutUser() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userCity")
        UserDefaults.standard.removeObject(forKey: "userProfileImage")

        let loginController = LoginViewController.loadFromNib()
        if let navController = navigationController {
            navController.setViewControllers([loginController], animated: true)
        }
    }

    // MARK: - Edit Button Action
    @IBAction func editButtonTapped(_ sender: UIButton) {
        print("Edit button tapped")
        showEditProfileScreen()
    }

    private func showEditProfileScreen() {
        let editProfileVC = EditViewController()
        navigationController?.pushViewController(editProfileVC, animated: true)
    }

    // MARK: - Helper to Show Alerts
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
