import UIKit

class PlayerView: UIView {

  let playButton: UIButton = {
    let button = UIButton()
    button.setImage(#imageLiteral(resourceName: "ic_play_circle_outline"), for: .normal)
    return button
  }()
  let slider: UISlider = {
    let slider = UISlider()
    slider.isContinuous = true
    slider.thumbTintColor = .blue
    slider.setThumbImage(#imageLiteral(resourceName: "ic_fiber_manual_record"), for: .normal)
    slider.setThumbImage(#imageLiteral(resourceName: "ic_fiber_manual_record"), for: .highlighted)
    return slider
  }()
  let timeLabel: UILabel = {
    let label = UILabel()
    label.font = label.font.withSize(12.0)
    label.text = "00:00"
    return label
  }()

  private let playButtonSize: CGFloat = 32.0

  var isPlaying: Bool = false {
    didSet {
      if isPlaying {
        playButton.setImage(#imageLiteral(resourceName: "ic_pause_circle_filled"), for: .normal)
      } else {
        playButton.setImage(#imageLiteral(resourceName: "ic_play_circle_outline"), for: .normal)
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupViews()
  }

  func reset() {
    slider.setValue(0.0, animated: false)
  }

  private func setupViews() {
    addSubview(playButton)
    playButton.translatesAutoresizingMaskIntoConstraints = false
    playButton.widthAnchor.constraint(equalToConstant: playButtonSize).isActive = true
    playButton.heightAnchor.constraint(equalToConstant: playButtonSize).isActive = true
    playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0).isActive = true
    playButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    addSubview(slider)
    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    slider.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 8.0).isActive = true

    addSubview(timeLabel)
    timeLabel.translatesAutoresizingMaskIntoConstraints = false
    timeLabel.widthAnchor.constraint(equalToConstant: 48.0).isActive = true
    timeLabel.leadingAnchor.constraint(equalTo: slider.trailingAnchor, constant: 4.0).isActive = true
    timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0).isActive = true
    timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
  }

  func sliderValueChanged(_ sender: UISlider) {
    debugPrint("sender.value: \(sender.value)")
    timeLabel.text = "\(sender.value)"
  }
}
