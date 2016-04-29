import UIKit

extension UIColor {

    static func randomColor() -> UIColor {
        let r = arc4random() % 256
        let g = arc4random() % 256
        let b = arc4random() % 256

        let rf = CGFloat(r) / 255
        let gf = CGFloat(g) / 255
        let bf = CGFloat(b) / 255

        return UIColor(red: rf, green: gf, blue: bf, alpha: 1.0)
    }
}
