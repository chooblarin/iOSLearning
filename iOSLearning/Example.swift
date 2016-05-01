import Foundation

enum Example: String {
    case Alert
    case Notification
    case Pager
    case PagerWithScrollView
    case Transition
    case Collection
    case TabBar
    case ParallaxImage

    static func allValues() -> [Example] {
        return [
            .Alert,
            .Notification,
            .Pager,
            .PagerWithScrollView,
            .Transition,
            .Collection,
            .TabBar,
            .ParallaxImage]
    }
}
