import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

  let containerPlayer: UIView = {
    let containerView = UIView()
    containerView.backgroundColor = .lightGray
    return containerView
  }()
  let togglePlayButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .blue
    return button
  }()
  let slider: UISlider = {
    let slider = UISlider()
    slider.thumbTintColor = .blue
    slider.maximumTrackTintColor = .red
    slider.minimumTrackTintColor = .green
    return slider
  }()

  let disposeBag: DisposeBag = DisposeBag()

  var timerDisposable: Disposable?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    setupViews()

    togglePlayButton.rx.tap.subscribe(onNext: { () in
      self.play()
    }).addDisposableTo(disposeBag)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    timerDisposable?.dispose()
  }

  func play() {
    if let disposable = timerDisposable {
      disposable.dispose()
    }

    timerDisposable = Observable<Int>
      .interval(1, scheduler: MainScheduler.instance)
      .take(10)
      .subscribe(onNext: { [weak self] (val: Int) in
        let floatVal = Float(val + 1) / 10.0
        debugPrint("val: \(floatVal)")
        self?.slider.setValue(floatVal, animated: true)
      })
  }

  private func setupViews() {
    containerPlayer.addSubview(togglePlayButton)
    togglePlayButton.translatesAutoresizingMaskIntoConstraints = false
    togglePlayButton.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
    togglePlayButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
    togglePlayButton.leadingAnchor
      .constraint(equalTo: containerPlayer.leadingAnchor, constant: 16.0).isActive = true
    togglePlayButton.centerYAnchor
      .constraint(equalTo: containerPlayer.centerYAnchor).isActive = true

    containerPlayer.addSubview(slider)
    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
    slider.centerYAnchor.constraint(equalTo: containerPlayer.centerYAnchor).isActive = true
    slider.leadingAnchor
      .constraint(equalTo: togglePlayButton.trailingAnchor, constant: 8.0).isActive = true
    slider.trailingAnchor
      .constraint(equalTo: containerPlayer.trailingAnchor, constant: -12.0).isActive = true

    view.addSubview(containerPlayer)
    containerPlayer.translatesAutoresizingMaskIntoConstraints = false
    containerPlayer.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
    containerPlayer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    containerPlayer.leadingAnchor
      .constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
    containerPlayer.trailingAnchor
      .constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
  }
}


