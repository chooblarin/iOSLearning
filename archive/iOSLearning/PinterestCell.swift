import UIKit

class PintarestCell: UICollectionViewCell {

    static let reuseIdentifier = "PinterestCell"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!

    var feedItem: FeedItem? {
        didSet {
            imageView.image = feedItem?.image
            captionLabel.text = feedItem?.title
            commentLabel.text = feedItem?.comment
        }
    }
}
