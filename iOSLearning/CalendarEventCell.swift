import UIKit

class CalendarEventCell: UICollectionViewCell {

    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)!
        setup()
    }

    func setup(){
        layer.cornerRadius = 10
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(red: 0, green: 0, blue: 0.7, alpha: 1).CGColor
        backgroundColor = UIColor(red: 164/255, green: 215/255, blue: 1, alpha: 1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFontOfSize(12)
        titleLabel.textColor = UIColor(red: 0, green: 64/255, blue: 128/255, alpha: 1)
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)

        let constraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-10-[title]-10-|",
            options: NSLayoutFormatOptions.DirectionLeadingToTrailing,
            metrics: nil,
            views: ["title":titleLabel])
        addConstraints(constraints)

        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-10-[title]-(>=8)-|",
            options: [],
            metrics: nil,
            views: ["title":titleLabel])
        addConstraints(vConstraints)
    }

    func bind(event:SampleCalendarEvent){
        titleLabel.text = event.title
        layoutIfNeeded()
    }
}

extension CalendarEventCell: ReusableView {}
