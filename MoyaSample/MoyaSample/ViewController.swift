import UIKit
import RxSwift
import Moya

class ViewController: UIViewController {

  let disposeBag = DisposeBag()

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

    GitHubProvider.request(.userProfile("chooblarin")).subscribe { event in
      switch event {
      case .next(let response):
        label.text = String(data: response.data, encoding: .utf8)
      case .error(let error):
        debugPrint(error)
      default: break
      }
    }.addDisposableTo(disposeBag)
  }
}
