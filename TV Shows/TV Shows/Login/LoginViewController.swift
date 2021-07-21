import UIKit
import SVProgressHUD
import Alamofire

struct User: Decodable{
    let id: String
    let email : String
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey{
        case id
        case email
        case imageUrl = "image_url"
    }
}

struct LoginData: Codable{
    let token: String
}

struct UserResponse: Decodable{
    let user: User
}

struct AuthInfo: Codable {

    let accessToken: String
    let client: String
    let tokenType: String
    let expiry: String
    let uid: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access-token"
        case client = "client"
        case tokenType = "token-type"
        case expiry = "expiry"
        case uid = "uid"
    }
    
    init(headers: [String: String]) throws {
        let data = try JSONSerialization.data(withJSONObject: headers, options: .prettyPrinted)
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }

    var headers: [String: String] {
        do {
            let data = try JSONEncoder().encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
            return jsonObject as? [String: String] ?? [:]
        } catch {
            return [:]
        }
    }

}



    class LoginViewController: UIViewController{
        
        @IBOutlet weak var emailField: UITextField!
        @IBOutlet weak var registerButton: UIButton!
        @IBOutlet weak var loginButton: UIButton!
        @IBOutlet weak var passwordField: UITextField!
        @IBOutlet weak var securityButton: UIButton!
        @IBOutlet weak var rememberMeButton: UIButton!
        private let newViewCon = HomeViewController()
    
        override func viewDidLoad() {
            super.viewDidLoad()
            rememberMeButton.setImage(UIImage(named: "ic-checkbox-selected"), for: .selected)
            rememberMeButton.setImage(UIImage(named: "ic-checkbox-unselected"), for: .normal)
            securityButton.setImage(UIImage(named: "ic-invisible"), for: .selected)
            securityButton.setImage(UIImage(named: "ic-visible"), for: .normal)
        }

        @IBAction func rememberMeSelected(_ sender: Any) {
            rememberMeButton.isSelected.toggle()
        }
    
        @IBAction func registerButtonSelected(_ sender: Any) {
            
            guard let emailText = emailField.text, !emailText.isEmpty else {
                print("email is empty")
                return
            }
            
            guard let passText = passwordField.text, !passText.isEmpty else {
                print("pass is empty")
                return
            }
            
            let email: String = emailField.text!
            let password: String = passwordField.text!
            
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
                .responseDecodable(of: UserResponse.self) { [self]response in
                    switch response.result{
                    case .success(let userResponse):
                        print("Successfully registered \(userResponse.user.email)")
                        SVProgressHUD.dismiss()
                        self.navigationController?.pushViewController(
                            newViewCon, animated: true)

                    case .failure(let error):
                        SVProgressHUD.dismiss()
                        print(error)
                    }
                }
             
        }
        
        @IBAction func loginButtonSelected(_ sender: Any) {
            
            
            guard let emailText = emailField.text, !emailText.isEmpty else {
                print("email is empty")
                return
            }
            
            guard let passText = passwordField.text, !passText.isEmpty else {
                print("pass is empty")
                return
            }
            
            let email: String = emailField.text!
            let password: String = passwordField.text!
            
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
                .responseDecodable(of: UserResponse.self) {[self] response in
                switch response.result{
                    case .success(let userResponse):
                        let headers = response.response?.headers.dictionary ?? [:]
                        handleSuccesfulLogin(for: userResponse.user, headers: headers)
                        self.navigationController?.pushViewController(
                            newViewCon, animated: true)
                    case .failure(let error):
                         print("API/Serialization failure: \(error)")
                        if error.responseCode == 401{
                            print("no such user")
                        }
                        SVProgressHUD.dismiss()
                }
            }

            
            func handleSuccesfulLogin(for user: User, headers: [String: String]) {
                guard let authInfo = try? AuthInfo(headers: headers) else {
                    print("Missing headers")
                    SVProgressHUD.dismiss()
                    return
                }
                print("Successfully logged in \(user.email)")
                SVProgressHUD.dismiss()
            }
        }

        
        @IBAction func securitySelected(_ sender: Any) {
            securityButton.isSelected.toggle()
            passwordField.isSecureTextEntry.toggle()
        }
    }

