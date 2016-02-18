import UIKit

class AlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions

    @IBAction func helloAlert(sender: UIButton) {
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        let alertController = UIAlertController(title: "Hello!", message: "message", preferredStyle: .Alert)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func helloActionSheet(sender: UIButton) {
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        let alertController = UIAlertController(title: "Hello!", message: "message", preferredStyle: .ActionSheet)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func multipleActionAlert1(sender: UIButton) {
        let okAction = UIAlertAction(title: "OK", style: .Default) { _ in print("ok") }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { _ in print("cancel") }

        let alertController = UIAlertController(title: "Hello!", message: "message", preferredStyle: .Alert)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func multipleActionAlert2(sender: UIButton) {
        let firstAction = UIAlertAction(title: "First", style: .Default) { _ in print("first") }
        let secondAction = UIAlertAction(title: "Second", style: .Default) { _ in print("second") }
        let thirdAction = UIAlertAction(title: "Third", style: .Default) { _ in print("third") }

        let alertController = UIAlertController(title: "Hello!", message: "message", preferredStyle: .Alert)
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(thirdAction)

        presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func helloInputForm(sender: UIButton) {
        let alertController = UIAlertController(title: "Hello!", message: "message", preferredStyle: .Alert)

        var usernameField: UITextField?
        var passwordField: UITextField?

        alertController.addTextFieldWithConfigurationHandler { textField in
            usernameField = textField
            textField.placeholder = "Username"
        }
        alertController.addTextFieldWithConfigurationHandler { textField in
            passwordField = textField
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        }

        let okAction = UIAlertAction(title: "OK", style: .Default) { _ in
            print("ok")
            if let username = usernameField?.text {
                print("username: \(username)")
            }
            if let password = passwordField?.text {
                print("password: \(password)")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { _ in print("cancel") }

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func dismiss(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
