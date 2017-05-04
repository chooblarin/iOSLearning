import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

  let playerView: PlayerView = {
    let playerView = PlayerView()
    playerView.layer.cornerRadius = 24.0
    playerView.backgroundColor = .lightGray
    return playerView
  }()

  let disposeBag: DisposeBag = DisposeBag()

  var timerDisposable: Disposable?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    setupViews()

    playerView.slider.rx.controlEvent(.touchDown)
      .subscribe(onNext: { [weak self] () in self?.pause() })
      .disposed(by: disposeBag)

    playerView.playButton.rx.tap
      .subscribe(onNext: { () in self.onPlayTapped() })
      .addDisposableTo(disposeBag)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    pause()
  }

  func onPlayTapped() {
    if let _ = timerDisposable {
      pause()
    } else {
      play()
    }
  }

  func play() {
    playerView.isPlaying = true
    timerDisposable = Observable<Int>
      .interval(0.05, scheduler: MainScheduler.instance)
      .take(200)
      .subscribe(onNext: { [weak self] (val: Int) in
        let floatVal = Float(val + 1) / 200.0
        self?.playerView.slider.setValue(floatVal, animated: true)
      })
  }

  func pause() {
    timerDisposable?.dispose()
    playerView.isPlaying = false
    timerDisposable = nil
  }

  private func setupViews() {
    view.addSubview(playerView)
    playerView.translatesAutoresizingMaskIntoConstraints = false
    playerView.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
    playerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    playerView.leadingAnchor
      .constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
    playerView.trailingAnchor
      .constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
  }
}


