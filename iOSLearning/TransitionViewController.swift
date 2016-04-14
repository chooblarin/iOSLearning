import UIKit

class TransitionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goNext(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Transition", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("Second")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
