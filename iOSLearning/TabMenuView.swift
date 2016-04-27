import UIKit

class TabMenuView: UIView {

    // MARK: - Properties
    var tabMenuItems: [String] = [] {
        didSet {
            tabMenuItemsCount = tabMenuItems.count
            beforeIndex = tabMenuItems.count
        }
    }
    var tabMenuItemSelectedBlock: ((index: Int, direction: UIPageViewControllerNavigationDirection) -> Void)?

    private var isInfinity: Bool = false
    private var option: TabMenuItemOption = TabMenuItemOption()
    private var beforeIndex: Int = 0
    private var selectedIndex: Int = 0
    private var tabMenuItemsCount: Int = 0
    private var shouldScrollToItem: Bool = false
    private var tabMenuItemsWidth: CGFloat = 0.0
    private var collectionViewContentOffsetX: CGFloat = 0.0
    private var selectedBarViewWidth: CGFloat = 0.0
    private var cellForSize: TabMenuCollectionViewCell!
    private var selectedBarViewLeftConstraint: NSLayoutConstraint?
    private var cachedCellSizes: [NSIndexPath: CGSize] = [:]

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

        let tabMenuCellIdentifier = TabMenuCollectionViewCell.cellIdentifier()
        let bundle = NSBundle(forClass: TabMenuView.self)
        let nib = UINib(nibName: tabMenuCellIdentifier, bundle: bundle)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: tabMenuCellIdentifier)
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
            selectedBarView.addConstraints([left, top])
        }
    }

    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension TabMenuView {
    func scrollSelectedBarView(index: Int, contentOffsetX: CGFloat) {
        if collectionViewContentOffsetX == 0.0 {
            collectionViewContentOffsetX = collectionView.contentOffset.x
        }
        let nextIndex: Int
        if isInfinity {
            if 0 == index && (beforeIndex - tabMenuItemsCount) == tabMenuItemsCount - 1 {
                nextIndex = tabMenuItemsCount * 2
            } else if index == tabMenuItemsCount - 1 && (beforeIndex - tabMenuItemsCount) == 0 {
                nextIndex = tabMenuItemsCount - 1
            } else {
                nextIndex = index + tabMenuItemsCount
            }
        } else {
            nextIndex = index
        }

        let currentIndexPath = NSIndexPath(forItem: selectedIndex, inSection: 0)
        let nextIndexPath = NSIndexPath(forItem: nextIndex, inSection: 0)

        guard let currentCell = collectionView.cellForItemAtIndexPath(currentIndexPath) as? TabMenuCollectionViewCell,
            let nextCell = collectionView.cellForItemAtIndexPath(nextIndexPath) as? TabMenuCollectionViewCell else {
            return
        }
        nextCell.setBarViewVisibility(false)
        currentCell.setBarViewVisibility(false)
        selectedBarView.hidden = false

        if 0.0 == selectedBarViewWidth {
            selectedBarViewWidth = currentCell.frame.width
        }
        let distance = (currentCell.frame.width + nextCell.frame.width) / 2.0
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
            if 0 < scrollRate {
                selectedBarViewLeftConstraint?.constant = currentCell.frame.minX + scrollRate * currentCell.frame.width
            } else {
                selectedBarViewLeftConstraint?.constant = currentCell.frame.minX + scrollRate * nextCell.frame.width
            }
        }
        selectedBarViewWidthConstraint.constant = selectedBarViewWidth + width
    }

    func scrollToHorizontalCenter() {
        let selectedIndexPath = NSIndexPath(forItem: selectedIndex, inSection: 0)
        collectionView.scrollToItemAtIndexPath(selectedIndexPath, atScrollPosition: .CenteredHorizontally, animated: false)
        collectionViewContentOffsetX = collectionView.contentOffset.x
    }

    func updateSelectedIndex(index: Int) {
        deselectVisibleCells()
        selectedIndex = isInfinity ? index + tabMenuItemsCount : index
        let selectedIndexPath = NSIndexPath(forItem: selectedIndex, inSection: 0)
        moveSelectedBarView(selectedIndexPath, animated: !isInfinity)
    }

    private func updateSelectedIndexForTap(index: Int) {
        deselectVisibleCells()

        if isInfinity && (index < tabMenuItemsCount) || (tabMenuItemsCount * 2 <= index) {
            selectedIndex = (index < tabMenuItemsCount) ? index + tabMenuItemsCount : index - tabMenuItemsCount
            shouldScrollToItem = true
        } else {
            selectedIndex = index
        }
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        moveSelectedBarView(indexPath, animated: true)
    }
    private func moveSelectedBarView(indexPath: NSIndexPath, animated: Bool) {
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: animated)
        layoutIfNeeded()
        beforeIndex = selectedIndex
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
        return isInfinity ? tabMenuItemsCount * 3 : tabMenuItemsCount
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TabMenuCollectionViewCell.cellIdentifier(), forIndexPath: indexPath) as! TabMenuCollectionViewCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }

    private func configureCell(cell: TabMenuCollectionViewCell, indexPath: NSIndexPath) {
        let adjustedIndex = isInfinity ? indexPath.item % tabMenuItemsCount : indexPath.item
        cell.item = tabMenuItems[adjustedIndex]
        cell.option = option
        // cell.isCurrent = adjustedIndex ==
        // TODO: set pressed block
    }
}

// MARK: - UICollectionViewDelegate

extension TabMenuView: UICollectionViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.dragging {
            selectedBarView.hidden = true
            let indexPath = NSIndexPath(forItem: selectedIndex, inSection: 0)
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? TabMenuCollectionViewCell {
                cell.setBarViewVisibility(true)
            }
        }
        if !isInfinity {
            return
        }

        if 0.0 == tabMenuItemsWidth {
            tabMenuItemsWidth = floor(scrollView.contentSize.width / 3.0)
        }

        if scrollView.contentOffset.x <= 0.0 ||
            scrollView.contentOffset.x > tabMenuItemsWidth * 2.0 {
            scrollView.contentOffset.x = tabMenuItemsWidth
        }
    }

    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        collectionView.userInteractionEnabled = true

        if !isInfinity {
            return
        }
        if shouldScrollToItem {
            let indexPath = NSIndexPath(forItem: selectedIndex, inSection: 0)
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
