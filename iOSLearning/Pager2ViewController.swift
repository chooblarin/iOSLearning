import UIKit

class Pager2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - IBAnctions

    @IBAction func launch(sender: UIButton) {
        let storyboard = UIStoryboard(name: "PageMenu", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        self.presentViewController(vc, animated: true, completion: nil)
    }
}
