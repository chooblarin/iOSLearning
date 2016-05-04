import UIKit

class ChatUIViewController: UIViewController {

    // IBOutlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var editorContainerBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter()
            .addObserver(self,
                         selector: #selector(ChatUIViewController.handleKeyboardWillShow(_:)),
                         name: UIKeyboardWillShowNotification,
                         object: nil)
        NSNotificationCenter.defaultCenter()
            .addObserver(self,
                         selector: #selector(ChatUIViewController.handleKeyboardWillHide(_:)),
                         name: UIKeyboardWillHideNotification,
                         object: nil)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func handleKeyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }

        if let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            editorContainerBottomConstraint.constant = keyboardFrame.size.height
            view.layoutIfNeeded()
        }
    }

    func handleKeyboardWillHide(notification: NSNotification) {
        editorContainerBottomConstraint.constant = 0
        view.layoutIfNeeded()
    }
}
