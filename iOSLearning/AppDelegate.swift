import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("didRegisterForRemoteNotificationsWithDeviceToken: \(deviceToken)")
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("didFailToRegisterForRemoteNotificationsWithError")
        print(error)
    }

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        switch application.applicationState {
        case .Active: NSNotificationCenter.defaultCenter().postNotificationName("notification", object: nil)
        case .Background: break
        case .Inactive: break
        }
    }

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
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
