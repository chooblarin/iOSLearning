import UserNotifications

enum NotificationAction: String {
    case going
    case interested
    case notGoing

    var title: String {
        switch self {
        case .going: return "Going"
        case .interested: return "Interested"
        case .notGoing: return "Not Going"
        }
    }

    var action: UNNotificationAction {
        return UNNotificationAction(identifier: self.rawValue, title: self.title, options: [])
    }
}
