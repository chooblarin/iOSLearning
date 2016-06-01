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
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 50
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CustomCollectionViewCell.reusableIdentifier, forIndexPath: indexPath) as! CustomCollectionViewCell
        cell.label.text = "Sec \(indexPath.section) / Item \(indexPath.item)"
        return cell
    }
}

class CustomCollectionViewLayout: UICollectionViewLayout {

    let CELL_HEIGHT: CGFloat = 30.0
    let CELL_WIDTH: CGFloat = 100.0

    var attributesDictionary = [NSIndexPath:UICollectionViewLayoutAttributes]()
    var contentSize = CGSizeZero

    override func collectionViewContentSize() -> CGSize {
        return self.contentSize
    }

    override func prepareLayout() {
        let numOfSections = collectionView!.numberOfSections()
        if 0 < numOfSections {
            (0..<numOfSections).forEach { section in
                let numOfItems = collectionView!.numberOfItemsInSection(section)
                if 0 < numOfItems {
                    (0..<numOfItems).forEach { i in
                        let indexPath = NSIndexPath(forItem: i, inSection: section)
                        let x = CGFloat(i) * CELL_WIDTH
                        let y = CGFloat(section) * CELL_HEIGHT
                        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                        attributes.frame = CGRectMake(x, y, CELL_WIDTH, CELL_HEIGHT)
                        attributes.zIndex = 1
                        attributesDictionary[indexPath] = attributes
                    }
                }
            }
        }
        // Update content size.
        let contentWidth = CGFloat(collectionView!.numberOfItemsInSection(0)) * CELL_WIDTH
        let contentHeight = CGFloat(collectionView!.numberOfSections()) * CELL_HEIGHT
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesDictionary.values
            .filter { attrs -> Bool in CGRectIntersectsRect(rect, attrs.frame)}
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesDictionary[indexPath]
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}