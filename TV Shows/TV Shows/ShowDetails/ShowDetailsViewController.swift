import UIKit
import Alamofire
import SVProgressHUD

class ShowDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var writeReviewButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!

     var showSelected : Show!
     var authInfo: AuthInfo!
     var instanceOfAllReviews: ReviewsResponse!

    var reviews: [Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        getAllShowReviews()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavBar() {
        self.title = showSelected.title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let showCell = tableView.dequeueReusableCell(
                withIdentifier: "TableViewCellShow",
                for: indexPath
            ) as! TableViewCellShow
            
            showCell.configure(with: showSelected)
            return showCell
        } else {
            let reviewCell = tableView.dequeueReusableCell(
                withIdentifier: "TableViewCellReview",
                for: indexPath
            ) as! TableViewCellReview
            
            let review = reviews[indexPath.row - 1]
            reviewCell.configure(with: review)
            return reviewCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count + 1
    }
    
    
    func getAllShowReviews(){
           AF
               .request(
                "https://tv-shows.infinum.academy/shows/\(showSelected.id)/reviews",
                   method: .get,
                   parameters:["page": "1" , "items": "100"],
                   headers: HTTPHeaders(authInfo.headers)
               )
               .validate()
               .responseDecodable(of: ReviewsResponse.self) {
                   [weak self] response in
                   guard let self = self else { return }
                   switch response.result{
                   case .success(let reviewsResponse):
                    self.reviews = reviewsResponse.reviews
                    self.instanceOfAllReviews = reviewsResponse
                    self.tableView.reloadData()
                   
                   case .failure(let error):
                       print("API/Serialization failure: \(error)")
                       SVProgressHUD.dismiss()
                   }
               }
       }
    
    @IBAction func writeReviewButtonPressed(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "newReview", bundle: .main)
        let detailsViewController = storyboard
            .instantiateViewController(
                withIdentifier: "writeReview"
            ) as! WriteReviewController
        
        let navigationController = UINavigationController(rootViewController: detailsViewController)

        detailsViewController.authInfo = authInfo
        detailsViewController.showSelected = showSelected
        detailsViewController.delegate = self
        present(navigationController, animated: true, completion: nil)
        
    }

}
extension ShowDetailsViewController: refreshTableDelegate {
    func fetchData() {
        getAllShowReviews()
    }
}

