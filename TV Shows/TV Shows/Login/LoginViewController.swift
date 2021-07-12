import UIKit

class LoginViewController: UIViewController {

    var numberOfTaps: Int = 0
    
    @IBOutlet weak var labelName: UILabel!

    
    @IBAction func consolePrint(_ sender: Any) {
        self.activityIndicator.isHidden = false
        numberOfTaps += 1
        labelName.text = "Pritisnuli ste gumb \(numberOfTaps) puta"
        if (numberOfTaps % 2 == 1){
            activityIndicator.startAnimating()
        }
        else{
            activityIndicator.stopAnimating()
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelName.text = "Brojim pritiske!"
        let delay = 3
        self.activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
