import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("didRegisterForRemoteNotificationsWithDeviceToken: \(deviceToken)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError")
        print(error)
    }

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        switch application.applicationState {
        case .active: NotificationCenter.default.post(name: Notification.Name(rawValue: "notification"), object: nil)
        case .background: break
        case .inactive: break
        }
    }

    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        if ("ACCEPT_IDENTIFIER" == identifier) {
            print("accept")
            print(notification.userInfo)
        }
        else if ("DECLINE_IDENTIFIER" == identifier) {
            print("decline")
        }
        completionHandler()
    }
}
