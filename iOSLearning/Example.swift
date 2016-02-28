import Foundation

enum Example {
    case Alert
    case Notification
    case Pager

    func toString() -> String {
        switch self {
        case .Alert: return "Alert"
        case .Notification: return "Notification"
        case .Pager: return "Pager"
        }
    }
}
