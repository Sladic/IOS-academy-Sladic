import UIKit
import SVProgressHUD
import Alamofire

class HomeViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    var authInfo: AuthInfo!
    var userResponse: UserResponse!
    var instanceOfUser: UserResponse!
    var showsResponsePermanent: ShowsResponse? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarSetup()
        getAllShows()
        createTableView()
    }

}
    extension HomeViewController: UITableViewDataSource{
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         showsResponsePermanent?.shows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TableViewCell.self),
            for: indexPath
        ) as! TableViewCell


        cell.configure(with: showsResponsePermanent!.shows[indexPath.row])
        return cell
        }
    
    }
    extension HomeViewController: UITableViewDelegate {
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let show = (showsResponsePermanent?.shows[indexPath.row])!
            navigateToDetails(for: show)
        }
    }
    
    
extension HomeViewController{
     func getAllShows(){
        AF
            .request(
            "https://tv-shows.infinum.academy/shows",
                method: .get,
                parameters:["page": "1" , "items": "100"],
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: ShowsResponse.self){[weak self]response in
                guard let self = self else { return }
                switch response.result{
                case .success(let showsResponse):
                    self.showsResponsePermanent = showsResponse
//                    let headers = response.response?.headers.dictionary ?? [:]
                    print(showsResponse)
                case .failure(let error):
                    print("API/Serialization failure: \(error)")
                    SVProgressHUD.dismiss()
                }
            }
    }
    
    func navigateToDetails(for show: Show) {
        let storyboard = UIStoryboard(name: "ShowDetails", bundle: .main)
        let detailsViewController = storyboard
            .instantiateViewController(
                withIdentifier: "ShowDetails"
            ) as! ShowDetailsViewController
        
        detailsViewController.showSelected = show
        detailsViewController.authInfo = authInfo
        
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    private func createTableView(){
        
            tableView.estimatedRowHeight = 110
            tableView.rowHeight = UITableView.automaticDimension

            tableView.tableFooterView = UIView()

            tableView.delegate = self
            tableView.dataSource = self
        }
    private func navBarSetup(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Shows"
        navigationItem.setHidesBackButton(true, animated: true)
        let profileDetailsItem = UIBarButtonItem(
            image: UIImage(named: "ic-profile"),
            style: .plain,
            target: self,
            action: #selector(profileDetailsActionHandler)
        )
        profileDetailsItem.tintColor = UIColor.gray
        navigationItem.rightBarButtonItem = profileDetailsItem
        }
    
        @objc
        private func profileDetailsActionHandler(){
            
            let storyboard = UIStoryboard(name: "UserProfile", bundle: .main)
            let profileViewController = storyboard
                .instantiateViewController(
                    withIdentifier: "userProfile"
                ) as! UserProfileController
            
            let navigationController = UINavigationController(rootViewController: profileViewController)

            profileViewController.authInfo = authInfo
            present(navigationController, animated: true, completion: nil)
            
        }
    }


