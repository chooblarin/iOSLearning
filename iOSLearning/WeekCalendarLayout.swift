import UIKit

let DaysPerWeek:CGFloat = 7
let HoursPerDay : CGFloat = 24
let HorizontalSpacing :CGFloat = 10
let HeightPerHour : CGFloat = 50
let DayHeaderHeight : CGFloat = 40
let HourHeaderWidth : CGFloat = 60

class WeekCalendarLayout: UICollectionViewLayout {

    var widthPerDay: CGFloat{
        let totalWidth = collectionViewContentSize().width - HourHeaderWidth
        let widthPerDay = totalWidth / DaysPerWeek
        return widthPerDay
    }

    override func collectionViewContentSize() -> CGSize {

        // Dont't scroll horizontally
        let contentWidth = collectionView!.bounds.width
        let contentHeight = DayHeaderHeight + (HeightPerHour * HoursPerDay)
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = [UICollectionViewLayoutAttributes]()

        // Cells
        let visibleIndexPaths = indexPathsOfItemsInRect(rect)
        for indexPath in visibleIndexPaths{
            if let attr = layoutAttributesForItemAtIndexPath(indexPath) {
                attrs.append(attr)
            }
        }

        // Supplementary views
        let dayHeaderViewIndexPaths = indexPathsOfDayHeaderViewsInRect(rect)
        for indexPath in dayHeaderViewIndexPaths{
            if let attr = layoutAttributesForSupplementaryViewOfKind(HeaderView.HeaderKinds.day, atIndexPath: indexPath) {
                attrs.append(attr)
            }
        }

        let hourHeadViewIndexPaths = indexPathsOfHourHeaderViewsInRect(rect)
        for indexPath in hourHeadViewIndexPaths{
            if let attr = layoutAttributesForSupplementaryViewOfKind(HeaderView.HeaderKinds.hour, atIndexPath: indexPath) {
                attrs.append(attr)
            }
        }
        return attrs
    }

    func indexPathsOfItemsInRect(rect: CGRect) -> [NSIndexPath] {
        let minVisibleDay = dayIndexFromXCoordinate(rect.minX)
        let maxVisibleDay = dayIndexFromXCoordinate(rect.maxX)
        let minVisibleHour = hourIndexFromYCoordiante(rect.minY)
        let maxVisibleHour = hourIndexFromYCoordiante(rect.maxY)

        NSLog("rect:\(rect),days:\(minVisibleDay)-\(maxVisibleDay),hours:\(minVisibleHour)-\(maxVisibleHour)")

        if let dataSource = collectionView?.dataSource as? CalendarDataSource {
            return dataSource.indexPathsOfEventsBetweenMinDayIndex(
                minVisibleDay,
                maxDayIndex: maxVisibleDay,
                minStartHour: minVisibleHour,
                maxStartHour: maxVisibleHour)
        } else {
            return []
        }
    }

    func dayIndexFromXCoordinate(xPosition:CGFloat) -> Int{
        let dayIndex = (xPosition - HourHeaderWidth) / widthPerDay
        return max(0, Int(dayIndex))
    }
    
    func hourIndexFromYCoordiante(yPosition:CGFloat) -> Int{
        let hourIndex = (yPosition - DayHeaderHeight) / HeightPerHour
        return max(0,Int(hourIndex))
    }
    
    
    func indexPathsOfDayHeaderViewsInRect(rect:CGRect) -> [NSIndexPath]{
        if rect.minY > DayHeaderHeight{
            return []
        }
        let minDayIndex = dayIndexFromXCoordinate(rect.minX)
        let maxDayIndex = dayIndexFromXCoordinate(rect.maxX)
        var indexPaths:[NSIndexPath] = []
        for index in minDayIndex...maxDayIndex {
            indexPaths.append(NSIndexPath(forItem: index, inSection: 0))
        }
        return indexPaths
    }
    
    func indexPathsOfHourHeaderViewsInRect(rect:CGRect) -> [NSIndexPath]{
        if rect.minX > HourHeaderWidth{
            return []
        }
        let minHourIndex = hourIndexFromYCoordiante(rect.minY)
        let maxHourIndex = hourIndexFromYCoordiante(rect.maxY)
        var indexPaths:[NSIndexPath] = []
        for index in minHourIndex...maxHourIndex {
            indexPaths.append(NSIndexPath(forItem: index, inSection: 0))
        }
        return indexPaths
    }
    
    func frameForEvent(event:SampleCalendarEvent) -> CGRect{
        let x = HourHeaderWidth + widthPerDay *  CGFloat(event.day)
        let y = DayHeaderHeight + HeightPerHour * CGFloat(event.startHour)
        let height = CGFloat(event.durationInHours) * HeightPerHour
        return CGRect(x: x, y: y, width: widthPerDay, height: height)
    }
}
