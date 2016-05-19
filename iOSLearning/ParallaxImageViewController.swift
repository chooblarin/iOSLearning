import UIKit
import RxSwift

class ParallaxImageViewController: UITableViewController {

    // MARK: - Properties

    var items: [UIImage] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        Observable.range(start: 0, count: 20)
            .map { String(format: "Image%02d", $0 % 10) }
            .map { UIImage(named: $0)! }
            .toArray()
            .subscribe(onNext: { [weak self] (images: [UIImage]) in
                self?.items = images
            })
            .addDisposableTo(disposeBag)
    }

    var cellHeight: CGFloat {
        return tableView.frame.width * 9 / 16
    }

    var imageVisibleHeight: CGFloat { // just an alias
        return cellHeight
    }

    let parallaxOffsetSpeed: CGFloat = 25

    var parallaxImageHeight: CGFloat {
        let maxOffset = (sqrt(pow(cellHeight, 2) + 4 * parallaxOffsetSpeed * tableView.frame.height) - cellHeight) / 2
        return imageVisibleHeight + maxOffset
    }

    func parallaxOffsetFor(newOffsetY: CGFloat, cell: UITableViewCell) -> CGFloat {
        return ((newOffsetY - cell.frame.origin.y) / parallaxImageHeight) * parallaxOffsetSpeed
    }

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ImageCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ImageCell
        cell.photoImageView.image = items[indexPath.row]
        cell.imageHeightConstraint.constant = parallaxImageHeight
        cell.imageTopConstraint.constant = parallaxOffsetFor(tableView.contentOffset.y, cell: cell)
        return cell
    }

    // MARK: - UIScrollViewDelegate

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = tableView.contentOffset.y
        tableView.visibleCells.forEach { (cell) in
            if let imageCell = cell as? ImageCell {
                imageCell.imageTopConstraint.constant = parallaxOffsetFor(offsetY, cell: imageCell)
            }
        }
    }

}

class ImageCell: UITableViewCell {

    // IBOutlets

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    
}
