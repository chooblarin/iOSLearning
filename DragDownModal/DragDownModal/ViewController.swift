import UIKit

class ViewController: UIViewController {

  let interactor = Interactor()

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func openButtonTapped(_ sender: UIButton) {
    let dragDownModalViewController = DragDownModalViewController()
    dragDownModalViewController.transitioningDelegate = self
    dragDownModalViewController.interactor = interactor
    present(dragDownModalViewController, animated: true, completion: nil)
  }
}

extension ViewController: UIViewControllerTransitioningDelegate {

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return DismissAnimator()
  }

  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactor.hasStarted ? interactor : nil
  }
}

class Interactor: UIPercentDrivenInteractiveTransition {
  var hasStarted = false
  var shouldFinish = false
}

class DismissAnimator: NSObject {}

extension DismissAnimator: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.6
  }
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard
      let from = transitionContext.viewController(forKey: .from),
      let to = transitionContext.viewController(forKey: .to) else {
        return
    }
    let containerView = transitionContext.containerView
    containerView.insertSubview(to.view, belowSubview: from.view)
    let screenBounds = UIScreen.main.bounds
    let bottomLeftCorner = CGPoint(x: 0.0, y: screenBounds.height)
    let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)

    UIView.animate(
      withDuration: transitionDuration(using: transitionContext),
      animations: {
      from.view.frame = finalFrame
    }, completion: {_ in
      let canceled = transitionContext.transitionWasCancelled
      transitionContext.completeTransition(!canceled)
    })
  }
}
