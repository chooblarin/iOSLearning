import UIKit

// @see(https://www.credera.com/blog/mobile-applications-and-web/building-a-multi-directional-uicollectionview-in-swift/)
class MultiDirectionCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UICollectionViewDataSource

extension MultiDirectionCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 50
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.reusableIdentifier, for: indexPath) as! CustomCollectionViewCell
        cell.label.text = "Sec \(indexPath.section) / Item \(indexPath.item)"
        return cell
    }
}

class CustomCollectionViewLayout: UICollectionViewLayout {

    let CELL_HEIGHT: CGFloat = 30.0
    let CELL_WIDTH: CGFloat = 100.0

    var attributesDictionary = [IndexPath:UICollectionViewLayoutAttributes]()
    var contentSize = CGSize.zero

    override var collectionViewContentSize : CGSize {
        return self.contentSize
    }

    override func prepare() {
        let numOfSections = collectionView!.numberOfSections
        if 0 < numOfSections {
            (0..<numOfSections).forEach { section in
                let numOfItems = collectionView!.numberOfItems(inSection: section)
                if 0 < numOfItems {
                    (0..<numOfItems).forEach { i in
                        let indexPath = IndexPath(item: i, section: section)
                        let x = CGFloat(i) * CELL_WIDTH
                        let y = CGFloat(section) * CELL_HEIGHT
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                        attributes.frame = CGRect(x: x, y: y, width: CELL_WIDTH, height: CELL_HEIGHT)
                        attributes.zIndex = 1
                        attributesDictionary[indexPath] = attributes
                    }
                }
            }
        }
        // Update content size.
        let contentWidth = CGFloat(collectionView!.numberOfItems(inSection: 0)) * CELL_WIDTH
        let contentHeight = CGFloat(collectionView!.numberOfSections) * CELL_HEIGHT
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesDictionary.values
            .filter { attrs -> Bool in rect.intersects(attrs.frame)}
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesDictionary[indexPath]
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
