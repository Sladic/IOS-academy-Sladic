import UIKit
import SVProgressHUD
import Alamofire

    class LoginViewController: UIViewController {
        
        // MARK: - IBOutlets
        
        @IBOutlet private weak var emailField: UITextField!
        @IBOutlet private weak var registerButton: UIButton!
        @IBOutlet private weak var loginButton: UIButton!
        @IBOutlet private weak var passwordField: UITextField!
        @IBOutlet private weak var securityButton: UIButton!
        @IBOutlet private weak var rememberMeButton: UIButton!
        @IBOutlet var loginView: UIView!
        // MARK: - Lifesycle methods
    
        override func viewDidLoad() {
            super.viewDidLoad()
            setupRememberMeButton()
            setupSecurityButton()
            setupNavBar()
        }
    }
        
        // MARK: - IBAction functions
        
        private extension LoginViewController {
            @IBAction func rememberMeSelected(_ sender: Any) {
                rememberMeButton.isSelected.toggle()
            }
        
            @IBAction func securitySelected(_ sender: Any) {
                securityButton.isSelected.toggle()
                passwordField.isSecureTextEntry.toggle()
            }
    
            @IBAction func registerButtonSelected(_ sender: Any) {
                
                registerButton.pulsate()
                
                guard let emailText = emailField.text, !emailText.isEmpty else {
                    print("email is empty")
                    return
                }
            
                guard let passText = passwordField.text, !passText.isEmpty else {
                    print("pass is empty")
                    return
                }
            
                let email: String = emailText
                let password: String = passText
                let params: [String: String] = [
                    "email": email,
                    "password": password
                ]
                SVProgressHUD.show()
                
                AF
                    .request(
                        "https://tv-shows.infinum.academy/users",
                        method: .post,
                        parameters: params,
                        encoder: JSONParameterEncoder.default
                    )
                    .validate()
                    .responseDecodable(of: UserResponse.self) { [weak self]response in
                        guard let self = self else { return }
                        switch response.result{
                        case .success(let userResponse):
                            print("Successfully registered \(userResponse.user.email)")
                            
                            SVProgressHUD.dismiss()
                            
                            let bundle = Bundle.main
                            let storyboard = UIStoryboard(name: "HomeView", bundle: bundle)
                            let homeViewController = storyboard.instantiateViewController(
                                withIdentifier: "HomeViewController"
                            )
                            self.navigationController?.pushViewController(homeViewController, animated: true)

                        case .failure(let error):
                            SVProgressHUD.dismiss()
                            print(error)
                        }
                    }
                }
        
            @IBAction func loginButtonSelected(_ sender: Any) {
                
                loginButton.flash()
            
                guard let emailText = emailField.text, !emailText.isEmpty else {
                    print("email is empty")
                    return
                }
            
                guard let passText = passwordField.text, !passText.isEmpty else {
                    print("pass is empty")
                    return
                }
            
                let email: String = emailText
                let password: String = passText
                let params: [String: String] = [
                    "email": email,
                    "password": password
                ]
                SVProgressHUD.show()
            
                AF
                    .request(
                        "https://tv-shows.infinum.academy/users/sign_in",
                        method: .post,
                        parameters: params,
                        encoder: JSONParameterEncoder.default
                    )
                    .validate()
                    .responseDecodable(of: UserResponse.self) {[weak self] response in
                        guard let self = self else { return }
                        switch response.result{
                        case .success(let userResponse):
                            let headers = response.response?.headers.dictionary ?? [:]
                            self.handleSuccesfulLogin(userResponseData: userResponse, for: userResponse.user, headers: headers)
                        case .failure(let error):
                            print("API/Serialization failure: \(error)")
                            self.emailField.shake()
                            self.passwordField.shake()
                            self.alertCall()
                            if error.responseCode == 401{
                                print("no such user")
                            }
                            SVProgressHUD.dismiss()
                        }
                    }
            }
        }
            // MARK: - Other (setup) methods

    private extension LoginViewController{
                
        func handleSuccesfulLogin(userResponseData: UserResponse, for user: User, headers: [String: String]) {
            SVProgressHUD.dismiss()
            guard let authInfo = try? AuthInfo(headers: headers) else {
                return
            }
            
            let bundle = Bundle.main
            let storyboard = UIStoryboard(name: "HomeView", bundle: bundle)
            let homeViewController = storyboard.instantiateViewController(
                withIdentifier: "HomeViewController"
            ) as! HomeViewController
            
            homeViewController.authInfo = authInfo
            homeViewController.userResponse = userResponseData
            
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }
        
        func setupRememberMeButton() {
                rememberMeButton.setImage(UIImage(named: "ic-checkbox-selected"), for: .selected)
                rememberMeButton.setImage(UIImage(named: "ic-checkbox-unselected"), for: .normal)
             }
        
        func setupSecurityButton() {
                securityButton.setImage(UIImage(named: "ic-invisible"), for: .selected)
                securityButton.setImage(UIImage(named: "ic-visible"), for: .normal)
             }
        
        func setupNavBar(){
            navigationController?.setNavigationBarHidden(true, animated: true)
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.sizeToFit()
        }

        func alertCall(){
            let alert = UIAlertController(title: "Invalid info", message: "You have provided invalid login info. Please try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            }
    }
// MARK: - Animations extensions

    extension UITextField {
        func shake() {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.05
            animation.repeatCount = 5
            animation.autoreverses = true
            animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
            animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
            layer.add(animation, forKey: "position")
        }
    }

    extension UIButton {
        func pulsate() {
            let pulse = CASpringAnimation(keyPath: "transform.scale")
            pulse.duration = 0.6
            pulse.fromValue = 0.98
            pulse.toValue = 1.0
            pulse.autoreverses = true
            pulse.repeatCount = 2
            pulse.initialVelocity = 0
            pulse.damping = 1.0
            layer.add(pulse, forKey: nil)
        }
        
        func flash() {
            let flash = CABasicAnimation(keyPath: "opacity")
            flash.duration = 0.3
            flash.fromValue = 1
            flash.toValue = 0.1
            flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            flash.autoreverses = true
            flash.repeatCount = 2
            layer.add(flash, forKey: nil)
        }
    }
