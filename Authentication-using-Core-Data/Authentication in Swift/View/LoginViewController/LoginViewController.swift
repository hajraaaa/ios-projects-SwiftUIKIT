import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createAccountLabel: UILabel!
    @IBOutlet weak var emailValidationLabel: UILabel!
    @IBOutlet weak var passwordValidationLabel: UILabel!

    let loginViewModel = LoginViewModel()

    static func loadFromNib() -> LoginViewController {
        return LoginViewController(nibName: "LoginViewController", bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupTextFieldLayout()
        setupGestureRecognizers()
        setupTextFieldImages()
        setupTextFieldTargets()
        setupDismissKeyboardGesture()
    }

    func setupTextFieldLayout() {
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.layer.shadowColor = UIColor.lightGray.cgColor
        emailTextField.layer.shadowOpacity = 0.5
        emailTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        emailTextField.layer.shadowRadius = 4
        
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.shadowColor = UIColor.lightGray.cgColor
        passwordTextField.layer.shadowOpacity = 0.5
        passwordTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        passwordTextField.layer.shadowRadius = 4
    }

    func setupGestureRecognizers() {
        let createAccountTapGesture = UITapGestureRecognizer(target: self, action: #selector(createAccountTapped))
        createAccountLabel.isUserInteractionEnabled = true
        createAccountLabel.addGestureRecognizer(createAccountTapGesture)
    }

    func setupTextFieldImages() {
        setLeftImageForTextField(emailTextField, imageName: "email", padding: 10)
        setLeftImageForTextField(passwordTextField, imageName: "pass", padding: 10)
    }

    func setupTextFieldTargets() {
        emailTextField.addTarget(self, action: #selector(emailTextFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldChanged), for: .editingChanged)
    }

    @objc func emailTextFieldChanged() {
        if let email = emailTextField.text {
            if isValidEmail(email) {
                emailValidationLabel.text = ""
                emailValidationLabel.textColor = .clear
            } else {
                emailValidationLabel.text = "Invalid Email"
                emailValidationLabel.textColor = .red
            }
        }
    }

    @objc func passwordTextFieldChanged() {
        if let password = passwordTextField.text {
            if isValidPassword(password) {
                passwordValidationLabel.text = ""
                passwordValidationLabel.textColor = .clear
            } else {
                passwordValidationLabel.text = "Password should be 4-8 characters"
                passwordValidationLabel.textColor = .red
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 4 && password.count <= 8
    }

    func setLeftImageForTextField(_ textField: UITextField, imageName: String, padding: CGFloat) {
        let imageView = UIImageView(image: UIImage(named: imageName))
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.width + padding, height: imageView.frame.height))
        containerView.addSubview(imageView)
        imageView.frame = CGRect(x: padding, y: 0, width: imageView.frame.width, height: imageView.frame.height)
        textField.leftView = containerView
        textField.leftViewMode = .always
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            if emailTextField.text?.isEmpty ?? true {
                emailValidationLabel.text = "Email is required"
                emailValidationLabel.textColor = .red
            } else {
                emailValidationLabel.text = ""
            }

            if passwordTextField.text?.isEmpty ?? true {
                passwordValidationLabel.text = "Password is required"
                passwordValidationLabel.textColor = .red
            } else {
                passwordValidationLabel.text = ""
            }
            return
        }
        
        if isValidEmail(email) && isValidPassword(password) {
            if let savedUser = CoreDataManager.shared.fetchUser(byEmail: email) {
                if savedUser.password == password {
                    print("User found: \(savedUser)")
                    
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set(savedUser.email, forKey: "userEmail")
                    UserDefaults.standard.set(savedUser.name, forKey: "userName")
                    UserDefaults.standard.set(savedUser.city, forKey: "userCity")
                    
                    if let imageData = savedUser.profileimage {
                        UserDefaults.standard.set(imageData, forKey: "userProfileImage")
                    }
                    UserDefaults.standard.synchronize()

                    let homeScreenController = HomeViewController(nibName: "HomeViewController", bundle: nil)
                    homeScreenController.userName = savedUser.name
                    homeScreenController.userCity = savedUser.city
                    homeScreenController.userEmail = savedUser.email
                    homeScreenController.userImage = UIImage(data: savedUser.profileimage ?? Data())
                    
                    navigationController?.pushViewController(homeScreenController, animated: true)
                } else {
                    showAlert(message: "Password didn't match. Please try again.")
                }
            } else {
                showAlert(message: "Email doesn't exist. Please check your email.")
            }
        } else {
            showAlert(message: "Invalid email or password")
        }
    }

    func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func createAccountTapped() {
        let signupViewController = SignUpVC.loadFromNib()
        navigationController?.pushViewController(signupViewController, animated: true)
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButton
        navigationController?.navigationBar.tintColor = .white
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
