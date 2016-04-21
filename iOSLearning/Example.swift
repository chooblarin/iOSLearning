import Foundation

enum Example {
    case Alert
    case Notification
    case Pager
    case Transition
    case Collection

    func toString() -> String {
        switch self {
        case .Alert: return "Alert"
        case .Notification: return "Notification"
        case .Pager: return "Pager"
        case .Transition: return "Transition"
        case .Collection: return "Collection"
        }
    }
}
