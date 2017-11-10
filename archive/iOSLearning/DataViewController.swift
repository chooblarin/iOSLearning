import UIKit

class DataViewController: UIViewController {

    var labelString = ""

    // MARK: - IBOutlets

    @IBOutlet weak var numberLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        numberLabel.text = labelString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
