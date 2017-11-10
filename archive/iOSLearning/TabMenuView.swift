import UIKit

class TabMenuView: UIView {

    // MARK: - Properties

    var pageItemPressedBlock: ((_ index: Int, _ direction: UIPageViewControllerNavigationDirection) -> Void)?
    var pageTabItems: [String] = [] {
        didSet {
            pageTabItemsCount = pageTabItems.count
            beforeIndex = pageTabItems.count
        }
    }

    fileprivate var isInfinity: Bool = false
    fileprivate var option: TabMenuItemOption = TabMenuItemOption()
    fileprivate var beforeIndex: Int = 0
    fileprivate var currentIndex: Int = 0
    fileprivate var pageTabItemsCount: Int = 0
    fileprivate var shouldScrollToItem: Bool = false
    fileprivate var pageTabItemsWidth: CGFloat = 0.0
    fileprivate var collectionViewContentOffsetX: CGFloat = 0.0
    fileprivate var currentBarViewWidth: CGFloat = 0.0
    fileprivate var cellForSize: TabMenuCollectionViewCell!
    fileprivate var cachedCellSizes: [IndexPath: CGSize] = [:]
    fileprivate var selectedBarViewLeftConstraint: NSLayoutConstraint?

    // MARK: - IBOutlets

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedBarView: UIView!
    @IBOutlet weak var selectedBarViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBarViewHeightConstraint: NSLayoutConstraint!

    init(isInfinity: Bool, option: TabMenuItemOption) {
        super.init(frame: CGRect.zero)
        self.isInfinity = isInfinity
        Bundle(for: TabMenuView.self).loadNibNamed("TabMenuView", owner: self, options: nil)
        addSubview(contentView)
        contentView.backgroundColor = option.tabBackgroundColor

        let left = NSLayoutConstraint(
            item: contentView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0.0)
        let top = NSLayoutConstraint(
            item: contentView,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1.0,
            constant: 0.0)
        let right = NSLayoutConstraint(
            item: self,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0.0)
        let bottom = NSLayoutConstraint (
            item: self,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0.0)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([left, top, right, bottom])

        let bundle = Bundle(for: TabMenuView.self)
        let nib = UINib(nibName: "TabMenuCollectionViewCell", bundle: bundle)
        let cellIdentifier = TabMenuCollectionViewCell.cellIdentifier()
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
        cellForSize = nib.instantiate(withOwner: nil, options: nil).first as! TabMenuCollectionViewCell

        collectionView.scrollsToTop = false

        selectedBarView.backgroundColor = option.currentColor
        if !isInfinity {
            selectedBarView.removeFromSuperview()
            collectionView.addSubview(selectedBarView)
            selectedBarView.translatesAutoresizingMaskIntoConstraints = false
            let left = NSLayoutConstraint(
                item: selectedBarView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: collectionView,
                attribute: .leading,
                multiplier: 1.0,
                constant: 0.0)
            let top = NSLayoutConstraint(
                item: selectedBarView,
                attribute: .top,
                relatedBy: .equal,
                toItem: collectionView,
                attribute: .top,
                multiplier: 1.0,
                constant: option.tabHeight - selectedBarView.frame.height)
            selectedBarViewLeftConstraint = left
            collectionView.addConstraints([left, top])
        }
        bottomBarViewHeightConstraint.constant = 1.0 / UIScreen.main.scale
    }

    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension TabMenuView {

    func scrollCurrentBarView(_ index: Int, contentOffsetX: CGFloat) {
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
        
        let currentIndexPath = IndexPath(item: currentIndex, section: 0)
        let nextIndexPath = IndexPath(item: nextIndex, section: 0)
        if let currentCell = collectionView.cellForItem(at: currentIndexPath) as? TabMenuCollectionViewCell,
            let nextCell = collectionView.cellForItem(at: nextIndexPath) as? TabMenuCollectionViewCell {
            nextCell.setBarViewVisibility(false)
            currentCell.setBarViewVisibility(false)
            selectedBarView.isHidden = false

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
        let currentIndexPath = IndexPath(item: currentIndex, section: 0)
        collectionView.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: false)
        collectionViewContentOffsetX = collectionView.contentOffset.x
    }

    func updateCurrentIndex(_ index: Int) {
        deselectVisibleCells()
        currentIndex = isInfinity ? index + pageTabItemsCount : index
        let currentIndexPath = IndexPath(item: currentIndex, section: 0)
        moveCurrentBarView(currentIndexPath, animated: !isInfinity)
    }

    fileprivate func updateCurrentIndexForTap(_ index: Int) {
        deselectVisibleCells()

        if isInfinity && (index < pageTabItemsCount) || (pageTabItemsCount * 2 <= index) {
            currentIndex = (index < pageTabItemsCount) ? index + pageTabItemsCount : index - pageTabItemsCount
            shouldScrollToItem = true
        } else {
            currentIndex = index
        }
        let indexPath = IndexPath(item: index, section: 0)
        moveCurrentBarView(indexPath, animated: true)
    }

    fileprivate func moveCurrentBarView(_ indexPath: IndexPath, animated: Bool) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        layoutIfNeeded()
        collectionViewContentOffsetX = 0.0
        currentBarViewWidth = 0.0
        if let cell = collectionView.cellForItem(at: indexPath) as? TabMenuCollectionViewCell {
            selectedBarView.isHidden = false
            cell.isCurrent = true
            cell.setBarViewVisibility(false)
            selectedBarViewWidthConstraint.constant = cell.frame.width
            if !isInfinity {
                selectedBarViewLeftConstraint?.constant = cell.frame.origin.x
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.layoutIfNeeded()
                if !self.isInfinity {
                    self.collectionView.isUserInteractionEnabled = true
                }
            }) 
        }
        beforeIndex = currentIndex
    }

    fileprivate func deselectVisibleCells() {
        collectionView.visibleCells
            .flatMap { $0 as? TabMenuCollectionViewCell }
            .forEach { $0.isCurrent = false }
    }
}

// MARK: - UICollectionViewDataSource

extension TabMenuView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isInfinity ? pageTabItemsCount * 3 : pageTabItemsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabMenuCollectionViewCell.cellIdentifier(), for: indexPath) as! TabMenuCollectionViewCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }

    fileprivate func configureCell(_ cell: TabMenuCollectionViewCell, indexPath: IndexPath) {
        let adjustedIndex = isInfinity ? indexPath.item % pageTabItemsCount : indexPath.item
        cell.item = pageTabItems[adjustedIndex]
        cell.option = option
        cell.isCurrent = adjustedIndex == (currentIndex % pageTabItemsCount)
        cell.tabMenuItemPressedBlock = { [weak self, weak cell] in
            var direction: UIPageViewControllerNavigationDirection = .forward
            if let pageTabItemsCount = self?.pageTabItemsCount,
                let currentIndex = self?.currentIndex {
                if self?.isInfinity == true {
                    if (indexPath.item < pageTabItemsCount) || (indexPath.item < currentIndex) {
                        direction = .reverse
                    }
                } else {
                    if indexPath.item < currentIndex {
                        direction = .reverse
                    }
                }
            }
            self?.pageItemPressedBlock?(adjustedIndex, direction)

            if cell?.isCurrent == false {
                // Not accept touch events to scroll the animation is finished
                self?.collectionView.isUserInteractionEnabled = false
            }
            self?.updateCurrentIndexForTap(indexPath.item)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension TabMenuView: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging {
            selectedBarView.isHidden = true
            let indexPath = IndexPath(item: currentIndex, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? TabMenuCollectionViewCell {
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

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        collectionView.isUserInteractionEnabled = true

        if !isInfinity {
            return
        }
        if shouldScrollToItem {
            let indexPath = IndexPath(item: currentIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            shouldScrollToItem = false
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TabMenuView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let size = cachedCellSizes[indexPath] {
            return size
        }
        configureCell(cellForSize, indexPath: indexPath)
        let size = cellForSize.sizeThatFits(CGSize(width: collectionView.bounds.width, height: option.tabHeight))
        cachedCellSizes[indexPath] = size
        return size
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
