import UIKit
import AVFoundation

class PintarestViewController: UICollectionViewController {

    var feedItems: [FeedItem] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            print("p ok")
            layout.delegate = self
        }

        let nib = UINib(nibName: PintarestCell.reuseIdentifier, bundle: NSBundle.mainBundle())
        collectionView?.registerNib(nib, forCellWithReuseIdentifier: PintarestCell.reuseIdentifier)
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)

        feedItems = FeedItem.create()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCellWithReuseIdentifier(PintarestCell.reuseIdentifier, forIndexPath: indexPath) as! PintarestCell
        cell.feedItem = feedItems[indexPath.item]
        return cell
    }
}

extension PintarestViewController: PinterestLayoutDelegate {

    func collectionView(collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let feedItem = feedItems[indexPath.item]
        let boundingRect = CGRectMake(0.0, 0.0, width, CGFloat(MAXFLOAT))
        let rect = AVMakeRectWithAspectRatioInsideRect(feedItem.image.size, boundingRect)
        return rect.size.height
    }

    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let feedItem = feedItems[indexPath.item]
        let space: CGFloat = 8.0
        let titleFont = UIFont.boldSystemFontOfSize(14.0)
        let titleHeight = feedItem.heightForTitle(titleFont, width: width - 2 * space)
        let font = UIFont.systemFontOfSize(10)
        let commentHeight = feedItem.heightForComment(font, width: width - 2 * space)
        let height = 12.0 + titleHeight + space + commentHeight + space
        return height
    }
}
