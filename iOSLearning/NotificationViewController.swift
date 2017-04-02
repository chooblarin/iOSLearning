import UIKit

class NotificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        registerNotification()

         NotificationCenter.default.addObserver(
            self,
            selector: #selector(NotificationViewController.handleNotification),
            name: NSNotification.Name(rawValue: "notification"),
            object: nil)
    }

    // MARK: - IBActions

    @IBAction func notifyAfterFiveSec(_ sender: UIButton) {
        let notification = UILocalNotification()
        notification.fireDate = Date(timeIntervalSinceNow: 5)
        notification.timeZone = TimeZone.current
        notification.alertTitle = "alert title"
        notification.alertBody = "alert body"
        notification.alertAction = "OK"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
    }

    @IBAction func notifyEveryMinute(_ sender: UIButton) {
        let notification = UILocalNotification()
        notification.fireDate = Date(timeIntervalSinceNow: 5)
        notification.timeZone = TimeZone.current
        notification.repeatInterval = .minute
        notification.alertTitle = "title every minute"
        notification.alertBody = "alert body"
        notification.alertAction = "OK"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
    }

    @IBAction func notifyWithAction(_ sender: UIButton) {
        let notification = UILocalNotification()
        notification.userInfo = ["foo": "bar"]
        notification.category = "INVITE_CATEGORY"
        notification.alertBody = "invite body"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.presentLocalNotificationNow(notification)
    }

    @IBAction func registerDevice(_ sender: UIButton) {
        UIApplication.shared.registerForRemoteNotifications()
    }

    func registerNotification() {
        let acceptAction = UIMutableUserNotificationAction()
        acceptAction.identifier = "ACCEPT_IDENTIFIER"
        acceptAction.title = "Accept"
        acceptAction.activationMode = .foreground
        acceptAction.isDestructive = false
        acceptAction.isAuthenticationRequired = false

        let declineAction = UIMutableUserNotificationAction()
        declineAction.identifier = "DECLINE_IDENTIFIER"
        declineAction.title = "Decline"
        declineAction.activationMode = .background
        declineAction.isDestructive = false
        declineAction.isAuthenticationRequired = false

        let inviteCategory = UIMutableUserNotificationCategory()
        inviteCategory.identifier = "INVITE_CATEGORY"
        inviteCategory.setActions([acceptAction, declineAction], for: .default)
        // For minimal (if there are more than two actions, use UIUserNotificationActionContext.Minimal)
        let categories = NSSet(objects: inviteCategory) as? Set<UIUserNotificationCategory>

        let application = UIApplication.shared
        application.cancelAllLocalNotifications()

        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: categories)
        application.registerUserNotificationSettings(settings)
    }

    func handleNotification() {
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alertController = UIAlertController(title: "Hello notification", message: "blur blur", preferredStyle: .alert)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}
