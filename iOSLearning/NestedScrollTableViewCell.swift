import UIKit

class NestedScrollTableViewCell: UITableViewCell {
}

extension NestedScrollTableViewCell: ReusableView {
}

extension NestedScrollTableViewCell: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NestedScrollCollectionViewCell.reusableIdentifier, forIndexPath: indexPath)
        return cell
    }
}

let numOfVisibleItems: Int = 4
let padding: CGFloat = 5.0

extension NestedScrollTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = collectionView.bounds.width / CGFloat(numOfVisibleItems) - padding
        let height = collectionView.bounds.height - (2 * padding)
        return CGSizeMake(width, height)
    }
}

class NestedScrollCollectionViewCell: UICollectionViewCell {
}

extension NestedScrollCollectionViewCell: ReusableView {
}
