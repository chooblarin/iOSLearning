import Foundation

enum Example {
    case Alert
    case Notification

    func toString() -> String {
        switch self {
        case .Alert: return "Alert"
        case .Notification: return "Notification"
        }
    }
}
