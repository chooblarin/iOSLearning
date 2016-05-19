import UIKit

protocol ReusableView {}

extension ReusableView where Self: UIView {

    static var reusableIdentifier: String {
        return String(self)
    }
}

protocol NibLoadableView: class {}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(self)
    }
}
