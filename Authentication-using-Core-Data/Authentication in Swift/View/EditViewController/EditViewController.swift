import UIKit
import CoreData
import DropDown

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var userName: String?
    var userCity: String?
    var userImage: UIImage?
    var userEmail: String?
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cityTextField.isUserInteractionEnabled = true
        reloadUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDismissKeyboardGesture()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.navigationController?.navigationBar.isHidden = true
        customizeTextFields(nameTextField, icon: UIImage(systemName: "person.crop.circle.fill"))
        customizeCityTextField(cityTextField, iconLeft: UIImage(systemName: "globe.asia.australia.fill"), iconRight: UIImage(systemName: "chevron.down.circle"))
        profileImageView.image = userImage ?? UIImage(named: "placeholder-image")
        nameTextField.text = userName
        cityTextField.text = userCity
        textfieldTap()
    }
    
    func textfieldTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textfieldTapped))
        cityTextField.addGestureRecognizer(tapGesture)
    }
    
    @objc func textfieldTapped() {
        let dropDown = DropDown()
        dropDown.anchorView = cityTextField
        dropDown.dataSource = ["Karachi", "Lahore", "Islamabad", "Peshawar", "Quetta", "Multan"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            cityTextField.text = item
        }
        dropDown.show()
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y: cityTextField.bounds.height)
        dropDown.topOffset = CGPoint(x: 0, y: -(dropDown.anchorView?.plainView.bounds.height)!)
    }
    
    private func reloadUserData() {
        guard let email = userEmail else { return }
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                userName = user.name
                userCity = user.city
                if let imageData = user.profileimage {
                    userImage = UIImage(data: imageData)
                }
                setupUI()
            }
        } catch {
            print("Failed to fetch user: \(error)")
        }
    }
    
    // MARK: - Keyboard Dismiss Setup
    func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func customizeTextFields(_ textField: UITextField, icon: UIImage?) {
        textField.borderStyle = .roundedRect
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowOffset = CGSize(width: 1, height: 1)
        textField.layer.shadowRadius = 4
        textField.layer.masksToBounds = false
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        if let iconImage = icon {
            let iconImageView = UIImageView(image: iconImage)
            iconImageView.tintColor = .gray.withAlphaComponent(0.8)
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.frame = CGRect(x: 10, y: 2, width: 20, height: 20)
            leftView.addSubview(iconImageView)
        }
        textField.leftView = leftView
        textField.leftViewMode = .always
    }
    
    private func customizeCityTextField(_ textField: UITextField, iconLeft: UIImage?, iconRight: UIImage?) {
        textField.borderStyle = .roundedRect
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowOffset = CGSize(width: 1, height: 1)
        textField.layer.shadowRadius = 4
        textField.layer.masksToBounds = false
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        if let iconImage = iconLeft {
            let iconImageView = UIImageView(image: iconImage)
            iconImageView.tintColor = .gray.withAlphaComponent(0.8)
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.frame = CGRect(x: 10, y: 2, width: 20, height: 20)
            leftView.addSubview(iconImageView)
        }
        textField.leftView = leftView
        textField.leftViewMode = .always
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        if let iconImage = iconRight {
            let iconImageView = UIImageView(image: iconImage)
            iconImageView.tintColor = .gray.withAlphaComponent(0.8)
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.frame = CGRect(x: 10, y: 2, width: 20, height: 20)
            rightView.addSubview(iconImageView)
        }
        textField.rightView = rightView
        textField.rightViewMode = .always
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty,
              let city = cityTextField.text, !city.isEmpty,
              let email = userEmail, !email.isEmpty else {
            showAlert(title: "Error", message: "Name, city, or email is missing.")
            return
        }
        updateUserData(name: name, city: city, email: email)
    }

    private func updateUserData(name: String, city: String, email: String) {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                user.name = name
                user.city = city
                if let imageData = profileImageView.image?.jpegData(compressionQuality: 1.0) {
                    user.profileimage = imageData
                }
                try context.save()
                print("User data updated successfully")
                showUpdateSuccessAlert()
            } else {
                print("No user found for email: \(email)")
                showAlert(title: "Error", message: "No user found with the provided email.")
            }
        } catch {
            print("Failed to update user: \(error)")
            showAlert(title: "Error", message: "Failed to update user data.")
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func showUpdateSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "User data updated successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            if let viewControllers = self.navigationController?.viewControllers {
                for controller in viewControllers {
                    if controller is HomeViewController {
                        self.navigationController?.popToViewController(controller, animated: true)
                        return
                    }
                }
            }
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true, completion: nil)
    }
}
