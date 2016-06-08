import UIKit

class NestedScrollViewController: UITableViewController {

    var categories = ["Action", "Drama", "Science Fiction", "Kids", "Horror"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
}

extension NestedScrollViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return categories.count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NestedScrollTableViewCell.reusableIdentifier, forIndexPath: indexPath)
        return cell
    }
}
