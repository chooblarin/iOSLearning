import UIKit

class PagerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showDemo(sender: UIButton) {
        let tabPagerViewController = TabPagerViewController.create()
        tabPagerViewController.tabMenuItems = tabMenuItems()
        tabPagerViewController.isInfinity = false
        navigationController?.pushViewController(tabPagerViewController, animated: false)
    }

    func tabMenuItems() -> [(viewController: UIViewController, title: String)] {
        let storyboard = UIStoryboard(name: "Pager", bundle: nil)

        let rvc = storyboard.instantiateViewControllerWithIdentifier("RedViewController")
        let gvc = storyboard.instantiateViewControllerWithIdentifier("GreenViewController")
        let bvc = storyboard.instantiateViewControllerWithIdentifier("BlueViewController")
        return [(rvc, "Red"), (gvc, "Green"), (bvc, "Blue")]
    }
}
