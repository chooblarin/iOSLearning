import UIKit

class PagerViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self

        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController], direction: .Forward, animated: true, completion: nil)
        }
    }

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        let storyboard = UIStoryboard(name: "Pager", bundle: nil)
        return [
            storyboard.instantiateViewControllerWithIdentifier("GreenViewController"),
            storyboard.instantiateViewControllerWithIdentifier("RedViewController"),
            storyboard.instantiateViewControllerWithIdentifier("BlueViewController")
        ]
    }()

    // MARK: -- IBActions

    @IBAction func dismiss(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: -- UIPageViewControllerDataSource

extension PagerViewController: UIPageViewControllerDataSource {

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }

        guard orderedViewControllers.count > previousIndex else { return nil }

        return orderedViewControllers[previousIndex]
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard nextIndex != orderedViewControllersCount else {
            return orderedViewControllers.first
        }
        guard orderedViewControllersCount > nextIndex else { return nil }

        return orderedViewControllers[nextIndex]
    }
}
