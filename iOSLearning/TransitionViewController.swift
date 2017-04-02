import UIKit

class TransitionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func goNext(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Transition", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Second")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
