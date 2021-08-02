import UIKit
import Alamofire

protocol refreshTableDelegate: AnyObject {
    func fetchData()
}

class WriteReviewController: UIViewController {
    
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    weak var delegateGrade : RatingViewDelegate?
    weak var delegate : refreshTableDelegate?
    var showSelected : Show!
    var authInfo: AuthInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
        navBarSetup()
        buttonSetup()
        ratingView.delegate = self
    }
    
    func navBarSetup(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(didSelectClose)
        )
        navigationItem.title = "Write a review"
    }
    
    @objc private func didSelectClose(){
        dismiss(animated: true, completion: nil)
    }

    @IBAction func postReviewButtonPressed(_ sender: Any) {
         sendNewReview()
    }
    
    func sendNewReview(){
        
        let rating: Int = ratingView.rating
        let comment: String = commentText.text ?? ""
        let showId: String = showSelected.id
        let params: [String: Any] = [
            "rating": rating,
            "comment": comment,
            "show_id": showId
        ]

               AF
                   .request(
                    "https://tv-shows.infinum.academy/reviews",
                       method: .post,
                       parameters: params,
                       headers: HTTPHeaders(authInfo.headers)
                   )
                   .validate()
                   .responseDecodable(of: ReviewResponse.self) {
                       [weak self] response in
                       guard let self = self else { return }
                       switch response.result{
                       case .success(let reviewResponse):
                            print(reviewResponse)
                        
                        self.delegate?.fetchData()
                        self.dismiss(animated: true, completion: nil)
                            
                       case .failure(let error):
                        self.alertCall()
                           print("API/Serialization failure: \(error)")
                       }
                   }
           }
    
    func alertCall(){
        let alert = UIAlertController(title: "Error", message: "An error occured while creating your review. Please try again!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The review alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
        }
    
    func buttonSetup(){
        submitButton.isEnabled = false
        submitButton.backgroundColor = UIColor .lightGray
    }

    
}

extension WriteReviewController: RatingViewDelegate {
    func didChangeRating(_ rating: Int) {
        submitButton.isEnabled = true
        submitButton.backgroundColor = UIColor(red: 0.32, green: 0.21, blue: 0.55, alpha: 1)
        
    }
    
    
}
