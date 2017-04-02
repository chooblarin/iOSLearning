import UIKit

protocol PinterestLayoutDelegate {
    
    func collectionView(_ collectionView:UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath, withWidth:CGFloat) -> CGFloat
    func collectionView(_ collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {

    var delegate: PinterestLayoutDelegate!

    let numberOfColumns = 2
    let cellPadding: CGFloat = 6.0

    fileprivate var cache = [UICollectionViewLayoutAttributes]()

    fileprivate var contentHeight: CGFloat  = 0.0
    fileprivate var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }

    override func prepare() {

        guard cache.isEmpty else { return }

        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        let xOffsets = (0 ..< numberOfColumns).map { CGFloat($0) * columnWidth }

        var column = 0
        var yOffsets = [CGFloat](repeating: 0.0, count: numberOfColumns)

        let numberOfItemsInSection = collectionView!.numberOfItems(inSection: 0)
        for item in 0..<numberOfItemsInSection {
            let indexPath = IndexPath(item: item, section: 0)

            let width = columnWidth - cellPadding * 2
            let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath, withWidth: width)
            let annotationHeight = delegate.collectionView(collectionView!, heightForAnnotationAtIndexPath: indexPath, withWidth: width)
            let height = cellPadding + photoHeight + annotationHeight + cellPadding
            let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
            yOffsets[column] = yOffsets[column] + height
            if column >= (numberOfColumns - 1) {
                column = 0
            } else {
                column += 1
            }
        }
    }

    override var collectionViewContentSize : CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
}
