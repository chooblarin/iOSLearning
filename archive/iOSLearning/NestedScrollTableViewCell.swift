import UIKit

class NestedScrollTableViewCell: UITableViewCell {
}

extension NestedScrollTableViewCell: ReusableView {
}

extension NestedScrollTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NestedScrollCollectionViewCell.reusableIdentifier, for: indexPath)
        return cell
    }
}

let numOfVisibleItems: Int = 4
let padding: CGFloat = 5.0

extension NestedScrollTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / CGFloat(numOfVisibleItems) - padding
        let height = collectionView.bounds.height - (2 * padding)
        return CGSize(width: width, height: height)
    }
}

class NestedScrollCollectionViewCell: UICollectionViewCell {
}

extension NestedScrollCollectionViewCell: ReusableView {
}
