import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        var vcs = [UIViewController]()
        for i in 0...10 {
            vcs.append(createViewController("page \(i)"))
        }
        self.viewControllers = vcs
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createViewController(_ title: String) -> UIViewController {
        let viewController = UIViewController()
        viewController.tabBarItem.title = title
        // viewController.tabBarItem.image = UIImage(named: "star")
        viewController.view.backgroundColor = UIColor.randomColor()
        return viewController
    }
}

// MARK: - UITabBarControllerDelegate

extension TabBarViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("shouldSelectViewController")
        return true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("didSelectViewController")
    }
}
