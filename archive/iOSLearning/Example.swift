import Foundation

enum Example: String {
    case Alert
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
    case Pinterest

    static func allValues() -> [Example] {
        return [
            .Alert,
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
            .Pinterest,
        ]
    }
}
