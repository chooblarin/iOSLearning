import UIKit

class PagerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showDemo(sender: UIButton) {
        let tabPagerViewController = TabPagerViewController.create()
        navigationController?.pushViewController(tabPagerViewController, animated: false)
    }
}
