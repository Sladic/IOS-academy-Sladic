import Foundation

struct  Show: Decodable {
    let id: String
    let average_rating: Double
    let description: String
    let imageUrl: String
    let numberOfReviews: Int
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case average_rating
        case description
        case imageUrl = "image_url"
        case numberOfReviews = "no_of_reviews"
        case title
    }
}

struct ShowsResponse: Decodable {
    let shows: [Show]
}
