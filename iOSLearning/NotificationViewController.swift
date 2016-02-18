import UIKit

class NotificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        registerNotification()

        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleNotification", name: "notification", object: nil)
    }

    // MARK: - IBActions

    @IBAction func notifyAfterFiveSec(sender: UIButton) {
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertTitle = "alert title"
        notification.alertBody = "alert body"
        notification.alertAction = "OK"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    @IBAction func notifyEveryMinute(sender: UIButton) {
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.repeatInterval = .Minute
        notification.alertTitle = "title every minute"
        notification.alertBody = "alert body"
        notification.alertAction = "OK"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    @IBAction func notifyWithAction(sender: UIButton) {
        let notification = UILocalNotification()
        notification.userInfo = ["foo": "bar"]
        notification.category = "INVITE_CATEGORY"
        notification.alertBody = "invite body"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }

    @IBAction func registerDevice(sender: UIButton) {
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }

    @IBAction func dismiss(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func registerNotification() {
        let acceptAction = UIMutableUserNotificationAction()
        acceptAction.identifier = "ACCEPT_IDENTIFIER"
        acceptAction.title = "Accept"
        acceptAction.activationMode = .Foreground
        acceptAction.destructive = false
        acceptAction.authenticationRequired = false

        let declineAction = UIMutableUserNotificationAction()
        declineAction.identifier = "DECLINE_IDENTIFIER"
        declineAction.title = "Decline"
        declineAction.activationMode = .Background
        declineAction.destructive = false
        declineAction.authenticationRequired = false

        let inviteCategory = UIMutableUserNotificationCategory()
        inviteCategory.identifier = "INVITE_CATEGORY"
        inviteCategory.setActions([acceptAction, declineAction], forContext: .Default)
        // For minimal (if there are more than two actions, use UIUserNotificationActionContext.Minimal)
        let categories = NSSet(objects: inviteCategory) as? Set<UIUserNotificationCategory>

        let application = UIApplication.sharedApplication()
        application.cancelAllLocalNotifications()

        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: categories)
        application.registerUserNotificationSettings(settings)
    }

    func handleNotification() {
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        let alertController = UIAlertController(title: "Hello notification", message: "blur blur", preferredStyle: .Alert)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}
