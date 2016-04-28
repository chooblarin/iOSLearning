import UIKit

class PagerWithScrollViewViewController: UIViewController {

    // Properties
    // let contentOffsetKeyPath = ""
    var viewControllers: [UIViewController] = [] {
        didSet {
            layoutChildViewControllers()
            scrollView.contentOffset.x = scrollView.frame.width
            viewControllers.forEach { vc in
                // Force load view before observing content offset
                _ = vc.view
//                vc.addObserver(self,
//                    forKeyPath: contentOffsetKeyPath,
//                    options: [.Old, .New],
//                    context: nil)
            }
        }
    }
    var currentPage = 0 {
        didSet {
            layoutChildViewControllers()
            //
        }
    }
    private var needsUpdateNavigationBar = true

    // MARK: - IBOutlets

    @IBOutlet weak var scrollView: UIScrollView!

    deinit {
        viewControllers.forEach { viewController in
//            viewController.removeObserver(self, forKeyPath: contentOffsetKeyPath)
        }
    }

    // MARK: - KVO

//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        guard keyPath == contentOffsetKeyPath else {
//            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
//            return
//        }
//        guard let oldValue = change?["old"] as? NSValue,
//            let newValue = change?["new"] as? NSValue
//            where object === viewControllers[currentPage] else {
//                return
//        }
//        needsUpdateNavigationBar = !oldValue.isEqualToValue(newValue)
//        updateNavigationBar()
//    }

    private func layoutChildViewControllers() {
        let previousChildViewControllers = childViewControllers
        let count = viewControllers.count

        let currentViewController = viewControllers[currentPage]
        let previousViewController = viewControllers[(currentPage - 1 + count) % count]
        let nextViewController = viewControllers[(currentPage + 1 + count) % count]

        childViewControllers.forEach { viewController in
            viewController.willMoveToParentViewController(nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParentViewController()
        }

        let size = scrollView.frame.size
        previousViewController.view.frame = CGRect(origin: CGPointZero, size: size)
        currentViewController.view.frame = CGRect(
            origin: CGPoint(x: scrollView.frame.width, y: 0.0),
            size: size)
        nextViewController.view.frame = CGRect(
            origin: CGPoint(x: scrollView.frame.width * 2.0, y: 0.0),
            size: size)
        [previousViewController, currentViewController, nextViewController]
            .forEach { (viewController) in
                addChildViewController(viewController)
                scrollView.addSubview(viewController.view)

                if !previousChildViewControllers.contains(viewController) {
                    // TODO
                }
                viewController.didMoveToParentViewController(self)
        }
    }

    private func updateNavigationBar() {
    }
}

// MARK: - UIViewController

extension PagerWithScrollViewViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.scrollsToTop = false

        let storyboard = UIStoryboard(name: "Pager", bundle: nil)
        let rvc = storyboard.instantiateViewControllerWithIdentifier("RedViewController")
        let gvc = storyboard.instantiateViewControllerWithIdentifier("GreenViewController")
        let bvc = storyboard.instantiateViewControllerWithIdentifier("BlueViewController")
        viewControllers = [rvc, gvc, bvc]
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        view.layoutIfNeeded()
        scrollView.contentOffset.x = scrollView.frame.width

        needsUpdateNavigationBar = true
        updateNavigationBar()
        layoutChildViewControllers()

        // if let navigationBar = navigationController?.navigationBar {
        // }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSizeMake(view.frame.width * 3.0, view.frame.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UIScrollViewDelegate

extension PagerWithScrollViewViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let count = viewControllers.count
        guard 0 < count else { return }
        
        switch scrollView.contentOffset.x {
        case let offset where offset < scrollView.frame.width * 0.5:
            currentPage = (currentPage - 1 + count) % count
            scrollView.contentOffset.x += scrollView.frame.width

        case let offset where scrollView.frame.width * 1.5 < offset:
            currentPage = (currentPage + 1 + count) % count
            scrollView.contentOffset.x -= scrollView.frame.width

        default:
            break
        }
    }
}
