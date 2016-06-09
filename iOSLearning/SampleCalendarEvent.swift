import UIKit

class SampleCalendarEvent: NSObject {

    let title = "Event\(random() % 10000)"
    let day =  random() % 7
    let startHour = random() % 20
    let durationInHours = random() % 5 + 1

    override init() {
        super.init()
    }

    func dayBetweenMinDayIndex(minDayIndex: Int, maxDayIndex: Int) -> Bool {
        return day >= minDayIndex && day <= maxDayIndex
    }

    func hourBetweenMinStartHour(minStartHour: Int, maxStartHour: Int) -> Bool {
        return startHour >= minStartHour && startHour <= maxStartHour
    }

    override var description: String {
        return "\(title)-\(day) \(startHour)"
    }
}

