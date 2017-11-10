import UIKit

class AlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - IBActions

    @IBAction func helloAlert(_ sender: UIButton) {
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alertController = UIAlertController(title: "Hello!", message: "message", preferredStyle: .alert)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func helloActionSheet(_ sender: UIButton) {
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alertController = UIAlertController(title: "Hello!", message: "message", preferredStyle: .actionSheet)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func multipleActionAlert1(_ sender: UIButton) {
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in print("ok") }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in print("cancel") }

        let alertController = UIAlertController(title: "Hello!", message: "message", preferredStyle: .alert)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func multipleActionAlert2(_ sender: UIButton) {
        let firstAction = UIAlertAction(title: "First", style: .default) { _ in print("first") }
        let secondAction = UIAlertAction(title: "Second", style: .default) { _ in print("second") }
        let thirdAction = UIAlertAction(title: "Third", style: .default) { _ in print("third") }

        let alertController = UIAlertController(title: "Hello!", message: "message", preferredStyle: .alert)
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(thirdAction)

        present(alertController, animated: true, completion: nil)
    }

    @IBAction func helloInputForm(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Hello!", message: "message", preferredStyle: .alert)

        var usernameField: UITextField?
        var passwordField: UITextField?

        alertController.addTextField { textField in
            usernameField = textField
            textField.placeholder = "Username"
        }
        alertController.addTextField { textField in
            passwordField = textField
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("ok")
            if let username = usernameField?.text {
                print("username: \(username)")
            }
            if let password = passwordField?.text {
                print("password: \(password)")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in print("cancel") }

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}
