import Foundation

enum Example {
    case Alert
    case Notification
    case Pager
    case Navigation

    func toString() -> String {
        switch self {
        case .Alert: return "Alert"
        case .Notification: return "Notification"
        case .Pager: return "Pager"
        case .Navigation: return "Navigation"
        }
    }
}
