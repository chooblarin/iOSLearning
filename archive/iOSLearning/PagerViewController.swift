import UIKit

class PagerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showDemo(_ sender: UIButton) {
        let tabPagerViewController = TabPagerViewController.create()
        tabPagerViewController.tabMenuItems = tabMenuItems()
        tabPagerViewController.isInfinity = false
        navigationController?.pushViewController(tabPagerViewController, animated: false)
    }

    func tabMenuItems() -> [(viewController: UIViewController, title: String)] {
        let storyboard = UIStoryboard(name: "Pager", bundle: nil)

        let rvc = storyboard.instantiateViewController(withIdentifier: "RedViewController")
        let gvc = storyboard.instantiateViewController(withIdentifier: "GreenViewController")
        let bvc = storyboard.instantiateViewController(withIdentifier: "BlueViewController")
        let rvc2 = storyboard.instantiateViewController(withIdentifier: "RedViewController")
        let gvc2 = storyboard.instantiateViewController(withIdentifier: "GreenViewController")
        let bvc2 = storyboard.instantiateViewController(withIdentifier: "BlueViewController")
        return [(rvc, "Red"), (gvc, "Green"), (bvc, "Blue"),
        (rvc2, "Red"), (gvc2, "Greeeeeeeeen"), (bvc2, "Blue")]
    }
}
