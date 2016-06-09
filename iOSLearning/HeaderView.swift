import UIKit

class HeaderView: UICollectionReusableView {

    struct HeaderKinds {
        static let day = "DayHeaderView"
        static let hour = "HourHeaderView"
    }

    let titleLabel = UILabel()
    let bottomBorderLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
 
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)!
        setup()
    }

    func setup() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFontOfSize(12)
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-10-[title]-10-|",
            options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
            metrics: nil,
            views: ["title":titleLabel])
        
        addConstraints(constraints)
        let constraint = NSLayoutConstraint(item: titleLabel,
                                            attribute: .CenterY,
                                            relatedBy: .Equal,
                                            toItem: self,
                                            attribute: .CenterY,
                                            multiplier: 1,
                                            constant: 0)
        addConstraint(constraint)

        let bottomBorderHeight: CGFloat = 1
        bottomBorderLayer.frame = CGRect(
            x: 0.0,
            y: frame.height,
            width: frame.width,
            height: bottomBorderHeight)
        bottomBorderLayer.backgroundColor = UIColor.blackColor().CGColor
        layer.addSublayer(bottomBorderLayer)
    }

    func bind(kind: String, indexPath: NSIndexPath) {
        if kind == HeaderKinds.day {
            titleLabel.text = "Day \(indexPath.item + 1)"
        } else if kind == HeaderKinds.hour {
             titleLabel.text = "\(indexPath.item + 1):00"
        }
    }
}

extension HeaderView: ReusableView {}
