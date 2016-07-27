import UIKit

protocol PinterestLayoutDelegate {
    
    func collectionView(collectionView:UICollectionView,
                        heightForPhotoAtIndexPath indexPath:NSIndexPath, withWidth:CGFloat) -> CGFloat
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {

    var delegate: PinterestLayoutDelegate!

    let numberOfColumns = 2
    let cellPadding: CGFloat = 6.0

    private var cache = [UICollectionViewLayoutAttributes]()

    private var contentHeight: CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }

    override func prepareLayout() {

        guard cache.isEmpty else { return }

        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        let xOffsets = (0 ..< numberOfColumns).map { CGFloat($0) * columnWidth }

        var column = 0
        var yOffsets = [CGFloat](count: numberOfColumns, repeatedValue: 0.0)

        let numberOfItemsInSection = collectionView!.numberOfItemsInSection(0)
        for item in 0..<numberOfItemsInSection {
            let indexPath = NSIndexPath(forItem: item, inSection: 0)

            let width = columnWidth - cellPadding * 2
            let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath, withWidth: width)
            let annotationHeight = delegate.collectionView(collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
            let height = cellPadding + photoHeight + annotationHeight + cellPadding
            let frame = CGRectMake(xOffsets[column], yOffsets[column], columnWidth, height)
            let insetFrame = CGRectInset(frame, cellPadding, cellPadding)

            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            contentHeight = max(contentHeight, CGRectGetMaxY(frame))
            yOffsets[column] = yOffsets[column] + height
            if column >= (numberOfColumns - 1) {
                column = 0
            } else {
                column += 1
            }
        }
    }

    override func collectionViewContentSize() -> CGSize {
        return CGSizeMake(contentWidth, contentHeight)
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { CGRectIntersectsRect($0.frame, rect) }
    }
}
