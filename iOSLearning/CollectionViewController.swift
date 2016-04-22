import UIKit
import RxSwift

private let reuseIdentifier = "Cell"
private let inset: CGFloat = 10.0
private let sectionInsets = UIEdgeInsets(top: inset,
                                         left: inset,
                                         bottom: inset,
                                         right: inset)

class CollectionViewController: UICollectionViewController {

    // MARK: - Properties
    var refreshControl: UIRefreshControl!

    var items:[Int] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(CollectionViewController.reloadData), forControlEvents: .ValueChanged)
        collectionView?.addSubview(refreshControl)

        Observable.range(start: 0, count: 20)
            .subscribeNext { [weak self] num in
                self?.items.append(num)
            }
            .addDisposableTo(disposeBag)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    func reloadData() {
        items = items.shuffle()
        refreshControl.endRefreshing()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        cell.backgroundColor = UIColor.yellowColor()
        let num = items[indexPath.row]
        let imageName = String(format: "Image%02d", num % 10)
        let image = UIImage(named: imageName)
        cell.photoImageView.image = image
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let num = items[indexPath.row]

        let action = UIAlertAction(title: "Cool!", style: .Default, handler: nil)
        let alertController = UIAlertController(title: "You Tapped", message: "This is No.\(num)", preferredStyle: .Alert)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size: CGFloat
        if 0 == indexPath.row {
            size = self.view.bounds.width - (2 * inset)
        } else {
            size = self.view.bounds.width / 2 - inset
        }
        return CGSize(width: size, height: size)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

// ===

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
