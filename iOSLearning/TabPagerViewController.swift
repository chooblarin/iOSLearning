import UIKit

class TabPagerViewController: UIPageViewController {

    static func create() -> TabPagerViewController {
        let storyboard = UIStoryboard(name: "TabPager", bundle: NSBundle(forClass: TabPagerViewController.self))
        return storyboard.instantiateInitialViewController() as! TabPagerViewController
    }

    // MARK: - Properties

    var isInfinity: Bool = false
    var option: TabMenuItemOption = TabMenuItemOption()

    var tabMenuItems: [(viewController: UIViewController, title: String)] = [] {
        didSet {
            tabItemsCount = tabMenuItems.count
        }
    }
    private var currentIndex: Int? {
        guard let viewController = self.viewControllers?.first else {
            return nil
        }
        return tabMenuItems.map { $0.viewController }.indexOf(viewController)
    }

    private var beforeIndex: Int = 0
    private var tabItemsCount: Int = 0
    private var defaultContentOffsetX: CGFloat = UIScreen.mainScreen().bounds.width
    private var shouldScrollCurrentBar: Bool = true
    lazy private var tabMenuView: TabMenuView = self.configureTabMenuView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup page view

        dataSource = self
        delegate = self
        automaticallyAdjustsScrollViewInsets = false

        if !tabMenuItems.isEmpty {
            setViewControllers(
                [tabMenuItems[beforeIndex].viewController],
                direction: .Forward,
                animated: false,
                completion: nil)
        }

        // setup scroll view

        let scrollView = view.subviews.flatMap { $0 as? UIScrollView }.first
        scrollView?.scrollsToTop = false
        scrollView?.delegate = self
        scrollView?.backgroundColor = option.pageBackgoundColor

        updateNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if nil == tabMenuView.superview {
            tabMenuView = configureTabMenuView()
        }
        if let currentIndex = currentIndex where isInfinity {
            tabMenuView.updateCurrentIndex(currentIndex)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateNavigationBar()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
    }

    func configureTabMenuView() -> TabMenuView {
        let tabMenuView = TabMenuView(isInfinity: isInfinity, option: option)
        tabMenuView.translatesAutoresizingMaskIntoConstraints = false
        
        let height = NSLayoutConstraint(
            item: tabMenuView,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .Height,
            multiplier: 1.0,
            constant: option.tabHeight)
        tabMenuView.addConstraint(height)
        view.addSubview(tabMenuView)

        let left = NSLayoutConstraint(
            item: tabMenuView,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Leading,
            multiplier: 1.0,
            constant: 0.0)
        let top = NSLayoutConstraint(
            item: tabMenuView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: topLayoutGuide,
            attribute: .Bottom,
            multiplier:1.0,
            constant: 0.0)
        let right = NSLayoutConstraint(
            item: view,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: tabMenuView,
            attribute: .Trailing,
            multiplier: 1.0,
            constant: 0.0)
        view.addConstraints([left, top, right])

        tabMenuView.pageTabItems = tabMenuItems.map { $0.title }
        tabMenuView.updateCurrentIndex(beforeIndex)
        
        tabMenuView.pageItemPressedBlock = { [weak self]
            (index: Int, direction: UIPageViewControllerNavigationDirection) in
            self?.displayControllerWithIndex(index, direction: direction, animated: true)
        }
        return tabMenuView
    }

    func updateNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(option.tabBackgroundImage, forBarMetrics: .Default)
        }
    }

    func displayControllerWithIndex(index: Int, direction: UIPageViewControllerNavigationDirection, animated: Bool) {
        beforeIndex = index
        shouldScrollCurrentBar = false
        let nextViewController = tabMenuItems[index].viewController

        setViewControllers(
            [nextViewController],
            direction: direction,
            animated: animated,
            completion: { [weak self] _ in
                self?.shouldScrollCurrentBar = true
                self?.beforeIndex = index
            })
    }
}

// MARK: - UIPageViewControllerDataSource

extension TabPagerViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return popViewController(viewController, isAfter: false)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return popViewController(viewController, isAfter: true)
    }
    
    private func popViewController(viewController: UIViewController, isAfter: Bool) -> UIViewController? {
        guard var index = tabMenuItems.map({ $0.viewController }).indexOf(viewController) else {
            return nil
        }
        index = index + (isAfter ? 1 : -1)
        if isInfinity {
            if index < 0 {
                index = tabMenuItems.count - 1
            } else if index == tabMenuItems.count {
                index = 0
            }
        }
        guard 0 <= index && index < tabMenuItems.count else {
            return nil
        }
        return tabMenuItems[index].viewController
    }
}

// MARK: - UIPageViewControllerDelegate

extension TabPagerViewController: UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        shouldScrollCurrentBar = true
        tabMenuView.scrollToHorizontalCenter()
        tabMenuView.collectionView.userInteractionEnabled = false // to prevent the hit repeatedly while animating
    }

    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentIndex = currentIndex where currentIndex < tabItemsCount {
            tabMenuView.updateCurrentIndex(currentIndex)
            beforeIndex = currentIndex
        }
        tabMenuView.collectionView.userInteractionEnabled = true
    }
}

// MARK: - UIScrollViewDelegate

extension TabPagerViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x == defaultContentOffsetX || !shouldScrollCurrentBar {
            return
        }
        var index = beforeIndex + (scrollView.contentOffset.x > defaultContentOffsetX ? 1 : -1)
        
        if index == tabItemsCount {
            index = 0
        } else if index < 0 {
            index = tabItemsCount - 1
        }
        let scrollOffsetX = scrollView.contentOffset.x - view.frame.width
        tabMenuView.scrollCurrentBarView(index, contentOffsetX: scrollOffsetX)
    }
}
