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
        
        self.navigationController?.navigationBar.barTintColor = UIColor.brown
        
        var titles = [String]()
        for i in 0..<10 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController
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
            pageViewController.setViewControllers([first], direction: .forward, animated: false, completion: nil)
        }
        
        let scrollView = pageViewController.view.subviews.flatMap { $0 as? UIScrollView }.first
        scrollView?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayViewControllerAt(_ index: Int, direction: UIPageViewControllerNavigationDirection, animated: Bool) {
        pageViewController.setViewControllers(
            [viewControllerArray[index]],
            direction: direction,
            animated: animated,
            completion: nil)
    }
}

// MARK: - UIPageViewControllerDataSource

extension PageMenuViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllerArray.index(of: viewController), 0 < index else {
            return nil
        }
        return viewControllerArray[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard var index = viewControllerArray.index(of: viewController) else { return nil }
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
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let vc = pageViewController.viewControllers?.first,
            let index = viewControllerArray.index(of: vc) {
            menuView.selectedIndex = index
        }
    }
}

// MARK: - UIScrollViewDelegate

extension PageMenuViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let count = viewControllerArray.count
        guard 0 < count else { return }
        
        // update selected bar
    }
}
