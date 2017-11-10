import UIKit

class ChatUIViewController: UIViewController {

    // MARK: - Properties

    var messages = [String]()

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var editorContainerBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(ChatUIViewController.handleKeyboardWillShow(_:)),
                         name: NSNotification.Name.UIKeyboardWillShow,
                         object: nil)
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(ChatUIViewController.handleKeyboardWillHide(_:)),
                         name: NSNotification.Name.UIKeyboardWillHide,
                         object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.dataSource = self
        textView.delegate = self

        // tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }

        if let keyboardValue: NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            editorContainerBottomConstraint.constant = keyboardValue.cgRectValue.size.height
            view.layoutIfNeeded()
        }
    }

    func handleKeyboardWillHide(_ notification: Notification) {
        editorContainerBottomConstraint.constant = 0
        view.layoutIfNeeded()
    }

    // MARK: - IBActions

    @IBAction func sendMessage(_ sender: UIButton) {
        if let message = textView.text {
            messages.append(message)
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            tableView.beginUpdates()
            tableView.insertRows(at: [indexPath], with: .bottom)
            tableView.endUpdates()
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        textView.text = ""
        let size = textView.sizeThatFits(textView.frame.size)
        textViewHeightConstraint.constant = size.height
        textView.resignFirstResponder()
    }
}

let cellIdentifier = "ChatMessageCell"

// MARK: - UITableViewDataSource

extension ChatUIViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChatMessageCell
        cell.messageLabel.text = messages[indexPath.row]
        return cell
    }
}

// MARK: - UITextViewDelegate

extension ChatUIViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        let maxHeight: CGFloat = 100.0
        guard textView.frame.size.height < maxHeight else { return }

        let size = textView.sizeThatFits(textView.frame.size)
        textViewHeightConstraint.constant = size.height
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        textView.scrollRangeToVisible(range)
        return true
    }
}
