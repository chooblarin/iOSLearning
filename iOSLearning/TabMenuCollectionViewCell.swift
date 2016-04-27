import UIKit

class TabMenuCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    var option = TabMenuItemOption()
    var item: String = "" {
        didSet {
            menuItemLabel.text = item
            menuItemLabel.invalidateIntrinsicContentSize()
            invalidateIntrinsicContentSize()
        }
    }

    var isCurrent: Bool = false {
        didSet {
            barView.hidden = !isCurrent
            if isCurrent {
                highlightTitle()
            } else {
                unHighlightTitle()
            }
            barView.backgroundColor = option.currentColor
            layoutIfNeeded()
        }
    }

    // MARK: - IBOutlets

    @IBOutlet weak var menuItemLabel: UILabel!
    @IBOutlet weak var barView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        barView.hidden = true
    }

    override func sizeThatFits(size: CGSize) -> CGSize {
        if 0 == item.characters.count {
            return CGSizeZero
        }
        return intrinsicContentSize()
    }

    override func intrinsicContentSize() -> CGSize {
        let width: CGFloat
        if let tabWidth = option.tabWidth where tabWidth > 0.0 {
            width = tabWidth
        } else {
            width = menuItemLabel.intrinsicContentSize().width + option.tabMargin * 2
        }
        return CGSizeMake(width, option.tabHeight)
    }

    func setBarViewVisibility(visible: Bool) {
        barView.hidden = !visible
    }

    func highlightTitle() {
        menuItemLabel.textColor = option.currentColor
        menuItemLabel.font = UIFont.boldSystemFontOfSize(option.fontSize)
    }

    func unHighlightTitle() {
        menuItemLabel.textColor = option.defaultColor
        menuItemLabel.font = UIFont.systemFontOfSize(option.fontSize)
    }

    class func cellIdentifier() -> String {
        return "TabMenuCollectionViewCell"
    }
}
