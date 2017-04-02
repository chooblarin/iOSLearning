import UIKit

class TabMenuCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    var tabMenuItemPressedBlock: ((Void) -> Void)?
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
            barView.isHidden = !isCurrent
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
        barView.isHidden = true
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if 0 == item.characters.count {
            return CGSize.zero
        }
        return intrinsicContentSize
    }

    override var intrinsicContentSize : CGSize {
        let width: CGFloat
        if let tabWidth = option.tabWidth, tabWidth > 0.0 {
            width = tabWidth
        } else {
            width = menuItemLabel.intrinsicContentSize.width + option.tabMargin * 2
        }
        return CGSize(width: width, height: option.tabHeight)
    }

    func setBarViewVisibility(_ visible: Bool) {
        barView.isHidden = !visible
    }

    func highlightTitle() {
        menuItemLabel.textColor = option.currentColor
        menuItemLabel.font = UIFont.boldSystemFont(ofSize: option.fontSize)
    }

    func unHighlightTitle() {
        menuItemLabel.textColor = option.defaultColor
        menuItemLabel.font = UIFont.systemFont(ofSize: option.fontSize)
    }

    class func cellIdentifier() -> String {
        return "TabMenuCollectionViewCell"
    }

    @IBAction func tappedTabMenuItem(_ sender: UIButton) {
        tabMenuItemPressedBlock?()
    }
}
