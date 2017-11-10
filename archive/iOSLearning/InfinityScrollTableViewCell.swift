import UIKit

extension InfinityScrollTableViewCell: ReusableView {}

extension InfinityScrollTableViewCell: NibLoadableView {}

class InfinityScrollTableViewCell: UITableViewCell {

    // IBOutlets

    @IBOutlet weak var numberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
