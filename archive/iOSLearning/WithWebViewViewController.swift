import UIKit

class WithWebViewViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!

    var adjusted = false

    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false

        webView.scrollView.delegate = self
        webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
        webView.scrollView.addSubview(headerView)

        imageView.image = UIImage(named: "Image01")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let request = URLRequest(url: URL(string: "https://news.ycombinator.com/")!)
        webView.loadRequest(request)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame.size.width = view.frame.width
        headerView.sizeToFit()

        webView.scrollView.contentInset.top = headerView.frame.height
        webView.scrollView.contentInset.bottom = bottomLayoutGuide.length
        headerView.frame.origin.y = -headerView.frame.height

        if !adjusted {
            webView.scrollView.contentOffset.y = -headerView.frame.height
            adjusted = true
        }
    }
}

extension WithWebViewViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scroll offset : \(scrollView.contentOffset.y)")
        if scrollView.contentOffset.y + headerView.frame.height < 0 {
            containerTopConstraint.constant = webView.scrollView.contentOffset.y + headerView.frame.height
            containerView.clipsToBounds = false
        }
    }
}
