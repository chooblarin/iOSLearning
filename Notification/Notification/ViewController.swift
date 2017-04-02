import UIKit
import UserNotifications
import CoreLocation

class ViewController: UIViewController {

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let button1 = UIButton(type: .system)
        button1.setTitle("Local notification after 3 seconds", for: .normal)
        let button2 = UIButton(type: .system)
        button2.setTitle("Local notification by location", for: .normal)
        let button3 = UIButton(type: .system)
        button3.setTitle("Local notification with actions", for: .normal)
        let button4 = UIButton(type: .system)
        button4.setTitle("Local notification with an attachment", for: .normal)

        let stackView = UIStackView(arrangedSubviews: [button1, button2, button3, button4])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10.0

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        button1.addTarget(self, action: #selector(notificationAfterThreeSeconds), for: .touchUpInside)
        button2.addTarget(self, action: #selector(notificationLocation), for: .touchUpInside)
        button3.addTarget(self, action: #selector(notificationWithActions), for: .touchUpInside)
        button4.addTarget(self, action: #selector(notificationAttachment), for: .touchUpInside)

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert]) { (granted, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            debugPrint("Granted: \(granted)")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .denied:
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }

    func notificationAfterThreeSeconds() {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Sub title"
        content.body = "Body"
        content.sound = UNNotificationSound.default()

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "Hello", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    func notificationLocation() {
        let content = UNMutableNotificationContent()
        content.body = "You are near my office"
        content.sound = UNNotificationSound.default()

        let c = CLLocationCoordinate2D(latitude: 37.910191, longitude: 139.061664)
        let region = CLCircularRegion(center: c, radius: 100.0, identifier: "office")
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        let request = UNNotificationRequest(identifier: "office", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    func notificationWithActions() {

        let actions: [NotificationAction] = [.going, .interested, .notGoing]
        let category = UNNotificationCategory(
            identifier: "message",
            actions: actions.map { $0.action },
            intentIdentifiers: actions.map { $0.rawValue },
            options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])

        let content = UNMutableNotificationContent()
        content.title = "Attendance confirmation"
        content.body = "Will you attend?"
        content.categoryIdentifier = "message"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "Hello with actions", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    func notificationAttachment() {
        guard let url = Bundle.main.url(forResource: "avengers-quicksilver", withExtension: "jpg", subdirectory: "assets") else {
            debugPrint("URL is unavailable")
            return
        }
        guard let attachment = try? UNNotificationAttachment(identifier: "attachment", url: url, options: nil) else {
            debugPrint("Attachment is unavailable")
            return
        }
        let content = UNMutableNotificationContent()
        content.body = "You didn't see that comming?"
        content.sound = UNNotificationSound.default()
        content.attachments = [attachment]
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "Hello with an attachment", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
