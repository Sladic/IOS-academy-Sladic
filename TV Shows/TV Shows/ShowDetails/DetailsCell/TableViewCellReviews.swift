import UIKit
import Kingfisher

class TableViewCellReview: UITableViewCell {
    
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet weak var reviewComment: UILabel!
    @IBOutlet weak var reviewerImage: UIImageView!
    @IBOutlet weak var reviewerUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ratingView.configure(withStyle: .small)
        ratingView.isEnabled = false
    }
}
extension TableViewCellReview{
    func configure(with item: Review) {
        reviewerUsername.text = item.user.email
        reviewComment.text = item.comment
        ratingView.rating = item.rating
        guard let imageUrl = item.user.imageUrl else { return }
        reviewerImage.kf.setImage(with: URL(string: imageUrl)!,
                                  placeholder: UIImage(named: "ic-profile-placeholder")
        )
    }
}
