import UIKit

class ViewController: UIViewController {

  let slider: UISlider = {
    let slider = UISlider()
    slider.backgroundColor = .gray
    return slider
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    view.addSubview(slider)
    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
    slider.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
    slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true

    slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .touchUpInside)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func sliderChanged(_ sender: UISlider) {
    debugPrint("aaa")
  }
}


