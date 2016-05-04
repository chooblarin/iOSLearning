import UIKit

class ChatUIViewController: UIViewController {

    // IBOutlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
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

        textView.delegate = self
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    @IBAction func sendMessage(sender: UIButton) {
        textView.text = ""
        let size = textView.sizeThatFits(textView.frame.size)
        textViewHeightConstraint.constant = size.height
        textView.resignFirstResponder()
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

// MARK: UITextViewDelegate

extension ChatUIViewController: UITextViewDelegate {

    func textViewDidChange(textView: UITextView) {
        let maxHeight: CGFloat = 100.0
        guard textView.frame.size.height < maxHeight else { return }

        let size = textView.sizeThatFits(textView.frame.size)
        textViewHeightConstraint.constant = size.height
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        textView.scrollRangeToVisible(range)
        return true
    }
}
