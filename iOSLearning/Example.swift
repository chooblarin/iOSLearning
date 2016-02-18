import Foundation

enum Example {
    case Alert

    func toString() -> String {
        switch self {
        case .Alert: return "Alert"
        }
    }
}
