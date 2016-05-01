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

    // MARK: - UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ImageCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ImageCell
        cell.photoImageView.image = items[indexPath.row]
        return cell
    }

    // MARK: - UIScrollViewDelegate

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if let imageCell = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? ImageCell {
            imageCell.imageCenterYConstraint.constant = -scrollView.contentOffset.y / 2.0
        }
    }
}

class ImageCell: UITableViewCell {

    // IBOutlets

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var imageCenterYConstraint: NSLayoutConstraint!
}
