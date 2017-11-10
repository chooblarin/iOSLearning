import UIKit

struct FeedItem {
    let image: UIImage
    let title: String
    let comment: String

    init(image: UIImage, title: String, comment: String) {
        self.image = image
        self.title = title
        self.comment = comment
    }

    func heightForTitle(_ font: UIFont, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let attrs = [NSFontAttributeName: font]
        let rect = NSAttributedString(string: title, attributes: attrs)
            .boundingRect(with: size,
                                  options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                  context: nil)
        return ceil(rect.height)
    }

    func heightForComment(_ font: UIFont, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let attrs = [NSFontAttributeName: font]
        let rect = NSString(string: comment)
            .boundingRect(with: size,
                                  options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                  attributes: attrs,
                                  context: nil)
        return ceil(rect.height)
    }
}

extension FeedItem {

    static func create() -> [FeedItem] {
        let images = [
            "Image00",
            "Image01",
            "Image02",
            "Image03",
            "Image04",
            "Image05",
            "Image06",
            "Image07",
            "Image08",
            "Image09"]
            .map { UIImage(named: $0)! }
        let titles = [
            "Image00",
            "Image01",
            "Image02",
            "Image03",
            "Image04",
            "Image05",
            "Image06",
            "Image07",
            "Image08",
            "Image09",
        ]
        let comment = [
            "Comment00",
            "Comment01",
            "Comment02",
            "Comment03",
            "Comment04",
            "Comment05",
            "Comment06",
            "Comment07",
            "Comment08",
            "Comment09",
        ]
        return zip(zip(images, titles), comment)
            .map { (left: (image: UIImage, title: String), comment: String) in
                FeedItem(image: left.image, title: left.title, comment: comment)
            }
    }
}
