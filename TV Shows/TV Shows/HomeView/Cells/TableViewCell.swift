import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var movieImage: UIImageView!

}

extension TableViewCell {

//    func configure(with item: ) {
//       
//        titleLabel.text = item.name
//    }
    
        func configure(with item: Show) {
            titleLabel.text = item.title
            movieImage.kf.setImage(with: URL(string: item.imageUrl),
                                  placeholder: UIImage(named: "ic-show-placeholder-vertical")
            )
        }
}
