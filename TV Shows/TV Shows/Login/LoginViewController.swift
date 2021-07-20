import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var securityButton: UIButton!
    @IBOutlet weak var rememberMeButton: UIButton!
    
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
    
    @IBAction func securitySelected(_ sender: Any) {
        securityButton.isSelected.toggle()
        passwordField.isSecureTextEntry.toggle()
    }
}
