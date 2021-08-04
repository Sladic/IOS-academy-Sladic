import UIKit
import Alamofire

class UserProfileController: UIViewController {
    var authInfo: AuthInfo!
    var instanceOfUser: User!


    override func viewDidLoad() {
        super.viewDidLoad()
        getUserData()
        // Do any additional setup after loading the view.
    }
    
    func getUserData(){
        AF
            .request(
            "https://tv-shows.infinum.academy/users/me",
                method: .get,
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: UserResponse.self){[weak self]response in
                guard let self = self else { return }
                switch response.result{
                case .success(let userResponse):
                    self.instanceOfUser = userResponse.user
//                    let headers = response.response?.headers.dictionary ?? [:]
                    print(userResponse)
                case .failure(let error):
                    print("API/Serialization failure: \(error)")
                }
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
