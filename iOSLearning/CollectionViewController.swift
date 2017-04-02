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
        refreshControl.addTarget(self, action: #selector(CollectionViewController.reloadData), for: .valueChanged)
        collectionView?.addSubview(refreshControl)

        Observable.from(0...20)
            .subscribe(onNext: { [weak self] (num: Int) in
                self?.items.append(num)
            })
            .addDisposableTo(disposeBag)

        // to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
    }

    func reloadData() {
        items = items.shuffled()
        refreshControl.endRefreshing()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.backgroundColor = UIColor.yellow
        let num = items[indexPath.row]
        let imageName = String(format: "Image%02d", num % 10)
        let image = UIImage(named: imageName)
        cell.photoImageView.image = image
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        cell.coverView.isHidden = false
    }

    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        cell.coverView.isHidden = true
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let num = items[indexPath.row]

        let action = UIAlertAction(title: "Cool!", style: .default, handler: nil)
        let alertController = UIAlertController(title: "You Tapped", message: "This is No.\(num)", preferredStyle: .alert)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGFloat
        if 0 == indexPath.row {
            size = self.view.bounds.width - (2 * inset)
        } else {
            size = self.view.bounds.width / 2 - inset
        }
        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

// ===

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
