import UIKit

class MasterViewController: UITableViewController {

    // MARK: - Properties

    let examples = Example.allValues()

    // MARK: - Life cycles

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let example = examples[indexPath.row]
        cell.textLabel!.text = example.rawValue
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let example = examples[indexPath.row]
        open(example)
    }

    fileprivate func open(_ example: Example) {
        let storyBoard = UIStoryboard(name: example.rawValue, bundle: nil)
        let viewController = storyBoard.instantiateInitialViewController()!
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
