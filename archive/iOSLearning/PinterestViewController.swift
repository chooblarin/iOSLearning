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

        let nib = UINib(nibName: PintarestCell.reuseIdentifier, bundle: Bundle.main)
        collectionView?.register(nib, forCellWithReuseIdentifier: PintarestCell.reuseIdentifier)
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)

        feedItems = FeedItem.create()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: PintarestCell.reuseIdentifier, for: indexPath) as! PintarestCell
        cell.feedItem = feedItems[indexPath.item]
        return cell
    }
}

extension PintarestViewController: PinterestLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let feedItem = feedItems[indexPath.item]
        let boundingRect = CGRect(x: 0.0, y: 0.0, width: width, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRect(aspectRatio: feedItem.image.size, insideRect: boundingRect)
        return rect.size.height
    }

    func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let feedItem = feedItems[indexPath.item]
        let space: CGFloat = 8.0
        let titleFont = UIFont.boldSystemFont(ofSize: 14.0)
        let titleHeight = feedItem.heightForTitle(titleFont, width: width - 2 * space)
        let font = UIFont.systemFont(ofSize: 10)
        let commentHeight = feedItem.heightForComment(font, width: width - 2 * space)
        let height = 12.0 + titleHeight + space + commentHeight + space
        return height
    }
}
