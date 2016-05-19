import UIKit
import RxSwift

let threshold: CGFloat = 100.0

class InfinityScrollViewController: UITableViewController {

    // MARK: - Properties
    var isLoading: Bool = false
    var items: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(
            UINib(nibName: InfinityScrollTableViewCell.nibName, bundle: nil),
            forCellReuseIdentifier: InfinityScrollTableViewCell.reusableIdentifier)
        tableView.registerNib(
            UINib(nibName: LoadingTableViewCell.nibName, bundle: nil),
            forCellReuseIdentifier: LoadingTableViewCell.reusableIdentifier)
        loadItems()
    }

    func loadItems() {
        guard !isLoading else { return }

        isLoading = true

        (0...20).toObservable()
            .map { String($0) }
            .toArray()
            .subscribeNext { [weak self] (items) in
                self?.items += items
                self?.isLoading = false
            }
            .addDisposableTo(disposeBag)
    }
}

// MARK: - Table view data source

extension InfinityScrollViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.item < items.count {
            let cell = tableView.dequeueReusableCellWithIdentifier(InfinityScrollTableViewCell.reusableIdentifier, forIndexPath: indexPath) as! InfinityScrollTableViewCell
            let item = items[indexPath.row]
            cell.numberLabel.text = item
            return cell

        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(LoadingTableViewCell.reusableIdentifier, forIndexPath: indexPath) as! LoadingTableViewCell
            return cell
        }
    }
}

// MARK: - UIScrollViewDelegate

extension InfinityScrollViewController {

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maximumOffset - contentOffset) <= threshold {
            loadItems()
        }
    }
}
