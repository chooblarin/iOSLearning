import UIKit

class PageMenuViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet weak var menuView: MenuView!
    
    // MARK: - Properties
    var pageViewController: UIPageViewController!
    var viewControllerArray: [UIViewController] = []
    var currentPage = 0 {
        didSet {
            if currentPage != menuView.selectedIndex {
                menuView.selectedIndex = currentPage
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationController?.navigationBar.barTintColor = UIColor.brownColor()
        
        var titles = [String]()
        for i in 0..<10 {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("DataViewController") as! DataViewController
            vc.labelString = i.description
            titles.append(i.description)
            viewControllerArray.append(vc)
        }
        menuView.menuTitle = titles
        menuView.pageItemPressBlock = {[weak self] (index: Int, direction: UIPageViewControllerNavigationDirection) in
            self?.displayViewControllerAt(index, direction: direction, animated: true)
        }
        
        pageViewController = childViewControllers.first as! UIPageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let first = viewControllerArray.first {
            pageViewController.setViewControllers([first], direction: .Forward, animated: false, completion: nil)
        }
        
        let scrollView = pageViewController.view.subviews.flatMap { $0 as? UIScrollView }.first
        scrollView?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayViewControllerAt(index: Int, direction: UIPageViewControllerNavigationDirection, animated: Bool) {
        pageViewController.setViewControllers(
            [viewControllerArray[index]],
            direction: direction,
            animated: animated,
            completion: nil)
    }
}

// MARK: - UIPageViewControllerDataSource

extension PageMenuViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllerArray.indexOf(viewController) where 0 < index else {
            return nil
        }
        return viewControllerArray[index - 1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard var index = viewControllerArray.indexOf(viewController) else { return nil }
        index += 1
        if index < viewControllerArray.count {
            return viewControllerArray[index]
        } else {
            return nil
        }
    }
}

// MARK: - UIPageViewControllerDelegate

extension PageMenuViewController: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let vc = pageViewController.viewControllers?.first,
            let index = viewControllerArray.indexOf(vc) {
            menuView.selectedIndex = index
        }
    }
}

// MARK: - UIScrollViewDelegate

extension PageMenuViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let count = viewControllerArray.count
        guard 0 < count else { return }
        
        // update selected bar
    }
}
