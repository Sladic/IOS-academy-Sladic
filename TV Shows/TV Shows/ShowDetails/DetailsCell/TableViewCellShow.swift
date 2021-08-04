import UIKit
import Kingfisher

class TableViewCellShow: UITableViewCell {

    @IBOutlet private weak var descriptionLabel: UILabel!

    @IBOutlet private weak var ratingView: RatingView!
    
    @IBOutlet weak var showImage: UIImageView!
    
}

extension TableViewCellShow {
    
        func configure(with item: Show) {
            
            showImage.kf.setImage(with: URL(string: item.imageUrl),
                                  placeholder: UIImage(named: "ic-show-placeholder-vertical")
            )
            descriptionLabel.text = item.description
            ratingView.rating = Int(item.average_rating)
            ratingView.configure(withStyle: .small)
            ratingView.isEnabled = false
        }
}
