import UIKit

class MenuView: UIView {

    class Cell: UICollectionViewCell {

        static let reuseIdentifier = "Cell"

        let titleLabel = UILabel()

        override var selected: Bool {
            didSet {
                if selected {
                    titleLabel.textColor = UIColor.whiteColor()
                } else {
                    titleLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
                }
            }
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }

        private func commonInit() {
            selected = false
            titleLabel.font = UIFont.boldSystemFontOfSize(14.0)
            titleLabel.textAlignment = .Center
            titleLabel.backgroundColor = UIColor.blackColor()
            addSubview(titleLabel)
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            titleLabel.frame.size = frame.size
            titleLabel.center.x = bounds.midX
            titleLabel.center.y = bounds.midY
        }
    }

    // MARK: - Properties

    var selectedIndex: Int {
        get {
            if let indexPath = collectionView.indexPathsForSelectedItems()?.first {
                return indexPath.item
            } else {
                return 0
            }
        }
        set {
            guard 0 < menuTitle.count else { return }

            let indexPath = NSIndexPath(forItem: newValue, inSection: 0)
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
            // update selection indicator
        }
    }

    var menuTitle: [String] = [] {
        didSet {
            collectionView.reloadData()
            layoutIfNeeded()
        }
    }

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        layout.scrollDirection = .Horizontal

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.registerClass(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        collectionView.backgroundColor = UIColor.cyanColor()
        collectionView.bounces = false
        return collectionView
    }()

    var pageItemPressBlock: ((index: Int, direction: UIPageViewControllerNavigationDirection) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = self.bounds
        collectionView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(collectionView)
    }
}

// MARK: - UICollectionViewDataSource

extension MenuView: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuTitle.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Cell.reuseIdentifier, forIndexPath: indexPath) as? Cell else {
            fatalError("Could not dequeue cell by reuse identifier \(Cell.reuseIdentifier)")
        }
        cell.titleLabel.text = menuTitle[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MenuView: UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        pageItemPressBlock?(index: indexPath.row, direction: .Forward)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MenuView: UICollectionViewDelegateFlowLayout {

    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //    }
}
