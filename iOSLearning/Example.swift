import Foundation

enum Example: String {
    case Alert
    case Notification
    case Pager
    case Pager2
    case PagerWithScrollView
    case Transition
    case Collection
    case TabBar
    case ParallaxImage
    case WithWebView
    case ChatUI
    case InfinityScroll
    case MultiDirectionCollectionView
    case NestedScroll
    case WeekCalendar

    static func allValues() -> [Example] {
        return [
            .Alert,
            .Notification,
            .Pager,
            .Pager2,
            .PagerWithScrollView,
            .Transition,
            .Collection,
            .TabBar,
            .ParallaxImage,
            .WithWebView,
            .ChatUI,
            .InfinityScroll,
            .MultiDirectionCollectionView,
            .NestedScroll,
            .WeekCalendar
        ]
    }
}
