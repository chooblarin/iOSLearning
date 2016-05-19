import UIKit

extension LoadingTableViewCell: ReusableView {}

extension LoadingTableViewCell: NibLoadableView {}

class LoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func show() {
        activityIndicatorView.startAnimating()
    }

    func hide() {
        activityIndicatorView.stopAnimating()
    }
}
