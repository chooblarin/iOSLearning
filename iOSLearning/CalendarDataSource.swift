import UIKit

class CalendarDataSource: NSObject {

    var events:[SampleCalendarEvent] = []

    override init() {
        super.init()
        generateSampleData()
    }

    func generateSampleData() {
        var maxCount = 20 + random() % 6
        while maxCount > 0 {
            events.append(SampleCalendarEvent())
            maxCount -= 1
        }
    }

    func eventAtIndexPath(indexPath: NSIndexPath) -> SampleCalendarEvent{
        return events[indexPath.item]
    }

    func indexPathsOfEventsBetweenMinDayIndex(minDayIndex: Int, maxDayIndex: Int, minStartHour: Int, maxStartHour: Int) -> [NSIndexPath]{
        var indexPaths:[NSIndexPath] = []
        var index = 0
        for event in events{
            if event.dayBetweenMinDayIndex(minDayIndex, maxDayIndex: maxDayIndex)
                && event.hourBetweenMinStartHour(minStartHour, maxStartHour: maxStartHour){
                indexPaths.append(NSIndexPath(forItem: index, inSection: 0))
            }
            index += 1
        }
        return indexPaths
    }
}

extension CalendarDataSource: UICollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let eventCell = collectionView.dequeueReusableCellWithReuseIdentifier(CalendarEventCell.reusableIdentifier, forIndexPath: indexPath) as! CalendarEventCell
        eventCell.bind(events[indexPath.row])
        return eventCell
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: HeaderView.reusableIdentifier, forIndexPath: indexPath) as! HeaderView
        headerView.bind(kind, indexPath: indexPath)
        return headerView
    }
}
