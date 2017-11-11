import UIKit

class DragDownModalViewController: UIViewController {

  weak var interactor: Interactor? = nil

  let closeButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Close", for: .normal)
    button.setTitleColor(.red, for: .normal)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }

  @objc func closeTapped() {
    dismiss(animated: true, completion: nil)
  }

  @objc func handleGesture(sender: UIPanGestureRecognizer) {

    let translation = sender.translation(in: view)
    let verticalMovement = translation.y / view.bounds.height
    let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
    let downwardMovementPercent = fmin(downwardMovement, 1.0)
    let progress = CGFloat(downwardMovementPercent)

    guard let interactor = interactor else { return }

    switch sender.state {
    case .began:
      interactor.hasStarted = true
      dismiss(animated: true, completion: nil)
    case .changed:
      let percentThreshold: CGFloat = 0.3
      interactor.shouldFinish = percentThreshold < progress
      interactor.update(progress)
    case .cancelled:
      interactor.hasStarted = false
      interactor.cancel()
    case .ended:
      interactor.hasStarted = false
      if interactor.shouldFinish {
        interactor.finish()
      } else {
        interactor.cancel()
      }
    default:
      break
    }
  }

  func setupViews() {
    view.backgroundColor = .yellow

    view.addSubview(closeButton)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    closeButton.topAnchor
      .constraint(equalTo: view.topAnchor, constant: 32.0).isActive = true
    closeButton.trailingAnchor
      .constraint(equalTo: view.trailingAnchor, constant: -12.0).isActive = true
    closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

    let gr = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(sender:)))
    view.addGestureRecognizer(gr)
  }
}
