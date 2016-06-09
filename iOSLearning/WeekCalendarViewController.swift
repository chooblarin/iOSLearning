import UIKit

class WeekCalendarViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let dataSource = CalendarDataSource()
        let calendarLayout = WeekCalendarLayout()

        collectionView.registerClass(CalendarEventCell.classForCoder(), forCellWithReuseIdentifier: CalendarEventCell.reusableIdentifier)
        collectionView.registerClass(HeaderView.classForCoder(), forSupplementaryViewOfKind: HeaderView.HeaderKinds.day, withReuseIdentifier: HeaderView.reusableIdentifier)
        collectionView.registerClass(HeaderView.classForCoder(), forSupplementaryViewOfKind: HeaderView.HeaderKinds.hour, withReuseIdentifier: HeaderView.reusableIdentifier)

        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = calendarLayout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
