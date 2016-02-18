import UIKit

class MasterViewController: UITableViewController {

    // MARK: - Properties

    var examples = [Example]()

    // MARK: - Life cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        examples.append(.Alert)
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let example = examples[indexPath.row]
        cell.textLabel!.text = example.toString()
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let example = examples[indexPath.row]
        open(example)
    }

    private func open(example: Example) {
        switch example {
        case .Alert:
            let storyBoard = UIStoryboard(name: "Alert", bundle: nil)
            let viewController = storyBoard.instantiateInitialViewController()!
            presentViewController(viewController, animated: true, completion: nil)
        }
    }
}
