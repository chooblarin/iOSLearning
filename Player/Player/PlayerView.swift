import UIKit

class PlayerView: UIView {

  let playButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .blue
    return button
  }()
  let slider: UISlider = {
    let slider = UISlider()
    slider.isContinuous = true
    slider.thumbTintColor = .blue
    slider.maximumTrackTintColor = .red
    slider.minimumTrackTintColor = .green
    return slider
  }()

  private let playButtonSize: CGFloat = 32.0

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupViews()
  }

  func setupViews() {
    addSubview(playButton)
    playButton.translatesAutoresizingMaskIntoConstraints = false
    playButton.widthAnchor.constraint(equalToConstant: playButtonSize).isActive = true
    playButton.heightAnchor.constraint(equalToConstant: playButtonSize).isActive = true
    playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
    playButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    addSubview(slider)
    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    slider.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 8.0).isActive = true
    slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0).isActive = true
  }
}
