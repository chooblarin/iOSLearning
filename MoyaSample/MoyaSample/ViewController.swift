import UIKit
import Moya

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    let label = UILabel()
    label.numberOfLines = 0
    view.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

    GitHubProvider.request(.userProfile("chooblarin")) { result in
      switch result {
      case .success(let response):
        label.text = String(data: response.data, encoding: .utf8)
      case .failure(let error):
        debugPrint(error)
      }
    }
  }
}

