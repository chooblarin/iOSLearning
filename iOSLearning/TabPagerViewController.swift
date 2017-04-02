import UIKit

class TabPagerViewController: UIPageViewController {

    static func create() -> TabPagerViewController {
        let storyboard = UIStoryboard(name: "TabPager", bundle: Bundle(for: TabPagerViewController.self))
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
    fileprivate var currentIndex: Int? {
        guard let viewController = self.viewControllers?.first else {
            return nil
        }
        return tabMenuItems.map { $0.viewController }.index(of: viewController)
    }

    fileprivate var beforeIndex: Int = 0
    fileprivate var tabItemsCount: Int = 0
    fileprivate var defaultContentOffsetX: CGFloat = UIScreen.main.bounds.width
    fileprivate var shouldScrollCurrentBar: Bool = true
    lazy fileprivate var tabMenuView: TabMenuView = self.configureTabMenuView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup page view

        dataSource = self
        delegate = self
        automaticallyAdjustsScrollViewInsets = false

        if !tabMenuItems.isEmpty {
            setViewControllers(
                [tabMenuItems[beforeIndex].viewController],
                direction: .forward,
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if nil == tabMenuView.superview {
            tabMenuView = configureTabMenuView()
        }
        if let currentIndex = currentIndex, isInfinity {
            tabMenuView.updateCurrentIndex(currentIndex)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }

    func configureTabMenuView() -> TabMenuView {
        let tabMenuView = TabMenuView(isInfinity: isInfinity, option: option)
        tabMenuView.translatesAutoresizingMaskIntoConstraints = false
        
        let height = NSLayoutConstraint(
            item: tabMenuView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1.0,
            constant: option.tabHeight)
        tabMenuView.addConstraint(height)
        view.addSubview(tabMenuView)

        let left = NSLayoutConstraint(
            item: tabMenuView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: view,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0.0)
        let top = NSLayoutConstraint(
            item: tabMenuView,
            attribute: .top,
            relatedBy: .equal,
            toItem: topLayoutGuide,
            attribute: .bottom,
            multiplier:1.0,
            constant: 0.0)
        let right = NSLayoutConstraint(
            item: view,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: tabMenuView,
            attribute: .trailing,
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
            navigationBar.setBackgroundImage(option.tabBackgroundImage, for: .default)
        }
    }

    func displayControllerWithIndex(_ index: Int, direction: UIPageViewControllerNavigationDirection, animated: Bool) {
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
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return popViewController(viewController, isAfter: false)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return popViewController(viewController, isAfter: true)
    }
    
    fileprivate func popViewController(_ viewController: UIViewController, isAfter: Bool) -> UIViewController? {
        guard var index = tabMenuItems.map({ $0.viewController }).index(of: viewController) else {
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
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        shouldScrollCurrentBar = true
        tabMenuView.scrollToHorizontalCenter()
        tabMenuView.collectionView.isUserInteractionEnabled = false // to prevent the hit repeatedly while animating
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentIndex = currentIndex, currentIndex < tabItemsCount {
            tabMenuView.updateCurrentIndex(currentIndex)
            beforeIndex = currentIndex
        }
        tabMenuView.collectionView.isUserInteractionEnabled = true
    }
}

// MARK: - UIScrollViewDelegate

extension TabPagerViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
