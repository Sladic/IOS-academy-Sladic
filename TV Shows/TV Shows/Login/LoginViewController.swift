import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet private weak var titleLabel: UILabel!
    
    private var numberOfTaps: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            SVProgressHUD.dismiss()
        }
        
        titleLabel.text = "Brojim pritiske!"
        let delay = 3
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    @IBAction private func incrementButtonActionHandler(_ sender: UIButton) {
        activityIndicator.isHidden = false
        numberOfTaps += 1
        titleLabel.text = "Pritisnuli ste gumb \(numberOfTaps) puta"
        
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }
    
}
