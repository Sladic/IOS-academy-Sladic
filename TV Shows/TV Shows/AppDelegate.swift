
import UIKit
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

struct UserResponse: Decodable{
    let user: User
}


 @main
 class AppDelegate: UIResponder, UIApplicationDelegate {

     var window: UIWindow?

     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /*
        let params: [String: String] = [
            "email": "dimitar.sladic5@gmail.com",
            "password": "infinum1"
        ]
        
        AF
            .request(
            "https://tv-shows.infinum.academy/users/sign_in",
                method: .post,
                parameters: params,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) {response in
                switch response.result{
                case .success(let userResponse):
                    print(userResponse.user.email)
                    print(userResponse.user.id)
                    print(userResponse.user.imageUrl)

                
                case .failure(let error):
                    print(error)
                }
            }
         */
         return true
      
     }
 }
