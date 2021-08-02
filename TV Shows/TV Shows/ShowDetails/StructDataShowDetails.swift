import Foundation

struct  Review: Decodable {
    let id: String
    let comment: String
    let rating: Int
    let showId: Int
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case rating
        case showId = "show_id"
        case user
    }
}

struct ReviewResponse: Decodable{
    let review: Review
}

struct ReviewsResponse: Decodable {
    let reviews: [Review]
}
