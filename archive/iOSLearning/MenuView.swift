import UIKit

class MenuView: UIView {

    class Cell: UICollectionViewCell {

        static let reuseIdentifier = "Cell"

        let titleLabel = UILabel()

        override var isSelected: Bool {
            didSet {
                if isSelected {
                    titleLabel.textColor = UIColor.white
                } else {
                    titleLabel.textColor = UIColor.white.withAlphaComponent(0.7)
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

        fileprivate func commonInit() {
            isSelected = false
            titleLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
            titleLabel.textAlignment = .center
            titleLabel.backgroundColor = UIColor.black
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
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                return indexPath.item
            } else {
                return 0
            }
        }
        set {
            guard 0 < menuTitle.count else { return }

            let indexPath = IndexPath(item: newValue, section: 0)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
            collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
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
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        collectionView.backgroundColor = UIColor.cyan
        collectionView.bounces = false
        return collectionView
    }()

    var pageItemPressBlock: ((_ index: Int, _ direction: UIPageViewControllerNavigationDirection) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    fileprivate func commonInit() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = self.bounds
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(collectionView)
    }
}

// MARK: - UICollectionViewDataSource

extension MenuView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuTitle.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell by reuse identifier \(Cell.reuseIdentifier)")
        }
        cell.titleLabel.text = menuTitle[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MenuView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pageItemPressBlock?(indexPath.row, .forward)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MenuView: UICollectionViewDelegateFlowLayout {

    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //    }
}
