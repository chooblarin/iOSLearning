import UIKit

class TabMenuView: UIView {

    // MARK: - Properties

    var pageItemPressedBlock: ((index: Int, direction: UIPageViewControllerNavigationDirection) -> Void)?
    var pageTabItems: [String] = [] {
        didSet {
            pageTabItemsCount = pageTabItems.count
            beforeIndex = pageTabItems.count
        }
    }

    private var isInfinity: Bool = false
    private var option: TabMenuItemOption = TabMenuItemOption()
    private var beforeIndex: Int = 0
    private var currentIndex: Int = 0
    private var pageTabItemsCount: Int = 0
    private var shouldScrollToItem: Bool = false
    private var pageTabItemsWidth: CGFloat = 0.0
    private var collectionViewContentOffsetX: CGFloat = 0.0
    private var currentBarViewWidth: CGFloat = 0.0
    private var cellForSize: TabMenuCollectionViewCell!
    private var cachedCellSizes: [NSIndexPath: CGSize] = [:]
    private var selectedBarViewLeftConstraint: NSLayoutConstraint?

    // MARK: - IBOutlets

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedBarView: UIView!
    @IBOutlet weak var selectedBarViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBarViewHeightConstraint: NSLayoutConstraint!

    init(isInfinity: Bool, option: TabMenuItemOption) {
        super.init(frame: CGRectZero)
        self.isInfinity = isInfinity
        NSBundle(forClass: TabMenuView.self).loadNibNamed("TabMenuView", owner: self, options: nil)
        addSubview(contentView)
        contentView.backgroundColor = option.tabBackgroundColor

        let left = NSLayoutConstraint(
            item: contentView,
            attribute: .Leading,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Leading,
            multiplier: 1.0,
            constant: 0.0)
        let top = NSLayoutConstraint(
            item: contentView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self,
            attribute: .Top,
            multiplier: 1.0,
            constant: 0.0)
        let right = NSLayoutConstraint(
            item: self,
            attribute: .Trailing,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Trailing,
            multiplier: 1.0,
            constant: 0.0)
        let bottom = NSLayoutConstraint (
            item: self,
            attribute: .Bottom,
            relatedBy: .Equal,
            toItem: contentView,
            attribute: .Bottom,
            multiplier: 1.0,
            constant: 0.0)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([left, top, right, bottom])

        let bundle = NSBundle(forClass: TabMenuView.self)
        let nib = UINib(nibName: "TabMenuCollectionViewCell", bundle: bundle)
        let cellIdentifier = TabMenuCollectionViewCell.cellIdentifier()
        collectionView.registerNib(nib, forCellWithReuseIdentifier: cellIdentifier)
        cellForSize = nib.instantiateWithOwner(nil, options: nil).first as! TabMenuCollectionViewCell

        collectionView.scrollsToTop = false

        selectedBarView.backgroundColor = option.currentColor
        if !isInfinity {
            selectedBarView.removeFromSuperview()
            collectionView.addSubview(selectedBarView)
            selectedBarView.translatesAutoresizingMaskIntoConstraints = false
            let left = NSLayoutConstraint(
                item: selectedBarView,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: collectionView,
                attribute: .Leading,
                multiplier: 1.0,
                constant: 0.0)
            let top = NSLayoutConstraint(
                item: selectedBarView,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: collectionView,
                attribute: .Top,
                multiplier: 1.0,
                constant: option.tabHeight - selectedBarView.frame.height)
            selectedBarViewLeftConstraint = left
            collectionView.addConstraints([left, top])
        }
        bottomBarViewHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
    }

    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension TabMenuView {

    func scrollCurrentBarView(index: Int, contentOffsetX: CGFloat) {
        var nextIndex = isInfinity ? index + pageTabItemsCount : index
        if isInfinity && index == 0 && (beforeIndex - pageTabItemsCount) == pageTabItemsCount - 1 {
            // Calculate the index at the time of transition to the first item from the last item of pageTabItems
            nextIndex = pageTabItemsCount * 2
        } else if isInfinity && (index == pageTabItemsCount - 1) && (beforeIndex - pageTabItemsCount) == 0 {
            // Calculate the index at the time of transition from the first item of pageTabItems to the last item
            nextIndex = pageTabItemsCount - 1
        }
        
        if collectionViewContentOffsetX == 0.0 {
            collectionViewContentOffsetX = collectionView.contentOffset.x
        }
        
        let currentIndexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
        let nextIndexPath = NSIndexPath(forItem: nextIndex, inSection: 0)
        if let currentCell = collectionView.cellForItemAtIndexPath(currentIndexPath) as? TabMenuCollectionViewCell,
            nextCell = collectionView.cellForItemAtIndexPath(nextIndexPath) as? TabMenuCollectionViewCell {
            nextCell.setBarViewVisibility(false)
            currentCell.setBarViewVisibility(false)
            selectedBarView.hidden = false

            if currentBarViewWidth == 0.0 {
                currentBarViewWidth = currentCell.frame.width
            }
            
            let distance = (currentCell.frame.width / 2.0) + (nextCell.frame.width / 2.0)
            let scrollRate = contentOffsetX / frame.width
            
            if fabs(scrollRate) > 0.6 {
                nextCell.highlightTitle()
                currentCell.unHighlightTitle()
            } else {
                nextCell.unHighlightTitle()
                currentCell.highlightTitle()
            }
            
            let width = fabs(scrollRate) * (nextCell.frame.width - currentCell.frame.width)
            if isInfinity {
                let scroll = scrollRate * distance
                collectionView.contentOffset.x = collectionViewContentOffsetX + scroll
            } else {
                if scrollRate > 0 {
                    selectedBarViewLeftConstraint?.constant = currentCell.frame.minX + scrollRate * currentCell.frame.width
                } else {
                    selectedBarViewLeftConstraint?.constant = currentCell.frame.minX + nextCell.frame.width * scrollRate
                }
            }
            selectedBarViewWidthConstraint.constant = currentBarViewWidth + width
        }
    }

    func scrollToHorizontalCenter() {
        let currentIndexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
        collectionView.scrollToItemAtIndexPath(currentIndexPath, atScrollPosition: .CenteredHorizontally, animated: false)
        collectionViewContentOffsetX = collectionView.contentOffset.x
    }

    func updateCurrentIndex(index: Int) {
        deselectVisibleCells()
        currentIndex = isInfinity ? index + pageTabItemsCount : index
        let currentIndexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
        moveCurrentBarView(currentIndexPath, animated: !isInfinity)
    }

    private func updateCurrentIndexForTap(index: Int) {
        deselectVisibleCells()

        if isInfinity && (index < pageTabItemsCount) || (pageTabItemsCount * 2 <= index) {
            currentIndex = (index < pageTabItemsCount) ? index + pageTabItemsCount : index - pageTabItemsCount
            shouldScrollToItem = true
        } else {
            currentIndex = index
        }
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        moveCurrentBarView(indexPath, animated: true)
    }

    private func moveCurrentBarView(indexPath: NSIndexPath, animated: Bool) {
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: animated)
        layoutIfNeeded()
        collectionViewContentOffsetX = 0.0
        currentBarViewWidth = 0.0
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? TabMenuCollectionViewCell {
            selectedBarView.hidden = false
            cell.isCurrent = true
            cell.setBarViewVisibility(false)
            selectedBarViewWidthConstraint.constant = cell.frame.width
            if !isInfinity {
                selectedBarViewLeftConstraint?.constant = cell.frame.origin.x
            }
            UIView.animateWithDuration(0.2) {
                self.layoutIfNeeded()
                if !self.isInfinity {
                    self.collectionView.userInteractionEnabled = true
                }
            }
        }
        beforeIndex = currentIndex
    }

    private func deselectVisibleCells() {
        collectionView.visibleCells()
            .flatMap { $0 as? TabMenuCollectionViewCell }
            .forEach { $0.isCurrent = false }
    }
}

// MARK: - UICollectionViewDataSource

extension TabMenuView: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isInfinity ? pageTabItemsCount * 3 : pageTabItemsCount
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TabMenuCollectionViewCell.cellIdentifier(), forIndexPath: indexPath) as! TabMenuCollectionViewCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }

    private func configureCell(cell: TabMenuCollectionViewCell, indexPath: NSIndexPath) {
        let adjustedIndex = isInfinity ? indexPath.item % pageTabItemsCount : indexPath.item
        cell.item = pageTabItems[adjustedIndex]
        cell.option = option
        cell.isCurrent = adjustedIndex == (currentIndex % pageTabItemsCount)
        cell.tabMenuItemPressedBlock = { [weak self, weak cell] in
            var direction: UIPageViewControllerNavigationDirection = .Forward
            if let pageTabItemsCount = self?.pageTabItemsCount, currentIndex = self?.currentIndex {
                if self?.isInfinity == true {
                    if (indexPath.item < pageTabItemsCount) || (indexPath.item < currentIndex) {
                        direction = .Reverse
                    }
                } else {
                    if indexPath.item < currentIndex {
                        direction = .Reverse
                    }
                }
            }
            self?.pageItemPressedBlock?(index: adjustedIndex, direction: direction)

            if cell?.isCurrent == false {
                // Not accept touch events to scroll the animation is finished
                self?.collectionView.userInteractionEnabled = false
            }
            self?.updateCurrentIndexForTap(indexPath.item)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension TabMenuView: UICollectionViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.dragging {
            selectedBarView.hidden = true
            let indexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? TabMenuCollectionViewCell {
                cell.setBarViewVisibility(true)
            }
        }
        if !isInfinity {
            return
        }

        if 0.0 == pageTabItemsWidth {
            pageTabItemsWidth = floor(scrollView.contentSize.width / 3.0)
        }

        if scrollView.contentOffset.x <= 0.0 ||
            scrollView.contentOffset.x > pageTabItemsWidth * 2.0 {
            scrollView.contentOffset.x = pageTabItemsWidth
        }
    }

    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        collectionView.userInteractionEnabled = true

        if !isInfinity {
            return
        }
        if shouldScrollToItem {
            let indexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
            shouldScrollToItem = false
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TabMenuView: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if let size = cachedCellSizes[indexPath] {
            return size
        }
        configureCell(cellForSize, indexPath: indexPath)
        let size = cellForSize.sizeThatFits(CGSizeMake(collectionView.bounds.width, option.tabHeight))
        cachedCellSizes[indexPath] = size
        return size
    }

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
}
