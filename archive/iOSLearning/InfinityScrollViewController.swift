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
        tableView.register(
            UINib(nibName: InfinityScrollTableViewCell.nibName, bundle: nil),
            forCellReuseIdentifier: InfinityScrollTableViewCell.reusableIdentifier)
        tableView.register(
            UINib(nibName: LoadingTableViewCell.nibName, bundle: nil),
            forCellReuseIdentifier: LoadingTableViewCell.reusableIdentifier)
        loadItems()
    }

    func loadItems() {
        guard !isLoading else { return }

        isLoading = true

        Observable.from(0...20)
            .map { String($0) }
            .toArray()
            .subscribe(onNext: { [weak self] (items: [String]) in
                self?.items += items
                self?.isLoading = false
            })
            .addDisposableTo(disposeBag)
    }
}

// MARK: - Table view data source

extension InfinityScrollViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item < items.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: InfinityScrollTableViewCell.reusableIdentifier, for: indexPath) as! InfinityScrollTableViewCell
            let item = items[indexPath.row]
            cell.numberLabel.text = item
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.reusableIdentifier, for: indexPath) as! LoadingTableViewCell
            cell.show()
            return cell
        }
    }
}

// MARK: - UIScrollViewDelegate

extension InfinityScrollViewController {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maximumOffset - contentOffset) <= threshold {
            loadItems()
        }
    }
}
