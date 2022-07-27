//
//  VHCarrouselCollectionView.swift
//  CarrouselCV
//
//  Created by Vidal HARA on 24.07.2022.
//

import UIKit

/// CarrouselCollectionView which multiplies source to make feel it is infinitely scrolls
///
/// You can trach centered indexPath and sourceIndexPath by setting `VHCarrouselCollectionView.carrouselDelegate`
///
/// -- Configuration:
///
/// You should call following functions in releated delegates
///
/// 1) `VHCarrouselCollectionView.scrollViewWillBeginDragging()`
///
/// 2) `VHCarrouselCollectionView.scrollViewWillEndDragging(...)`
///
/// 3) `VHCarrouselCollectionView.scrollViewDidEndScrollingAnimation()`
///
/// -- Usage:
///
/// - Attention: You should call
///
///  * `scrollViewWillBeginDragging()` in `UICollectionViewDelegate.scrollViewWillBeginDragging(...)`
///  * `scrollViewWillEndDragging(...)` in `UICollectionViewDelegate.scrollViewWillEndDragging(...)`
///  * `scrollViewDidEndScrollingAnimation()` in `UICollectionViewDelegate.scrollViewDidEndScrollingAnimation(...)`
///
/// While using indexPath to get your related item from your source list,
/// you should normalize it because this collectionView multiplies the indexPath.
///
/// Ex:
///  ```
/// let source: [UIColor] = [.purple, .green]
/// func collectionView(
///     _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
/// ) -> UICollectionViewCell {
///     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LocalCVC
///     let sourceIndex = indexPath.vhCarrouselSourceIndexPath(for: collectionView).item
///     cell.backgroundColor = source[sourceIndex]
///     return cell
/// }
///  ```
///
/// - Attention: This collectionView has some limitations:
///
///  * Only Horizontal direction supported
///  * Only one section supported
///  * Layout should be UICollectionViewFlowLayout
///  * All cell sizes should be same
///  * Supplementary elements are not supported (Ex: Header, Footer)
///
open class VHCarrouselCollectionView: UICollectionView {

    internal lazy var localSource = LocalSource(collectionView: self)

    /// The object that acts as the delegate of the collection view.
    ///
    /// The delegate must adopt the `VHCarrouselCollectionViewDelegate` protocol.
    /// The delegate object is responsible for informing centered item.
    open weak var carrouselDelegate: VHCarrouselCollectionViewDelegate?

    /// The object that provides the data for the collection view.
    ///
    /// The data source must adopt the UICollectionViewDataSource protocol.
    /// The collection view maintains a weak reference to the data source object.
    ///
    /// - Attention: When you set dataSoruce, property value will be changed and funneled to your functions
    open override var dataSource: UICollectionViewDataSource? {
        didSet {
            guard dataSource !== localSource else { return }
            localSource.assignedDataSource = dataSource
            dataSource = localSource
        }
    }

    /// Centered source indexPath. You can safely use this indexPath while you using for source operations.
    open var centeredSourceIndexPath: IndexPath? {
        didSet {
            guard let centeredSourceIndexPath = centeredSourceIndexPath else { return }
            carrouselDelegate?.vhCarrouselView?(self, centeredSourceIndexPath: centeredSourceIndexPath)
        }
    }

    /// Centered indexPath which can be used for view operations. You **should not** use it for source operations
    ///
    /// - Attention: When you want to indexPath for source operations you should use `centeredSourceIndexPath`.
    open var centeredIndexPath: IndexPath? {
        didSet {
            if let centeredIndexPath = centeredIndexPath {
                carrouselDelegate?.vhCarrouselView?(self, centeredIndexPath: centeredIndexPath)
            }
            let itemCount = localSource.rawTotalCount
            if let centeredIndexPath = centeredIndexPath, itemCount > .zero {
                centeredSourceIndexPath = .init(item: centeredIndexPath.row % itemCount, section: .zero)
            } else {
                centeredSourceIndexPath = nil
            }
        }
    }

    /// Source multiplier logic
    ///
    /// When number of item is 1, this property **ignored** and **used .single** instead.
    open var sourceMultiplier: SourceMultiplier = .triple {
        didSet {
            localSource.sourceMultiplier = sourceMultiplier
        }
    }

    /// The frame rectangle, which describes the view’s location and size in its superview’s coordinate system.
    open override var frame: CGRect {
        didSet {
            guard oldValue != frame else { return }
            localSource.updateInsets()
        }
    }

    /// Creates a collection view object with the specified frame and layout.
    ///
    /// - Parameters:
    ///   - frame: The frame rectangle for the collection view, measured in points.
    ///   The origin of the frame is relative to the superview in which you plan to add it.
    ///   This frame is passed to the superclass during initialization.
    ///   - layout: The layout **should be** an UICollectionViewFlowLayout
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupUI()
    }

    /// View init coder
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    /// Reloads all of the data for the collection view.
    ///
    /// This will center first source item.
    ///
    /// When you do not want to change scroll position you can call `reloadData(scrollToInitial: false)`
    open override func reloadData() {
        reloadData(scrollToInitial: true)
    }

    /// Scrolls the collection view contents until the specified item is visible.
    ///
    /// - Attention: If animated is false,
    /// collection view may not infinitely scroll.
    ///
    /// If you want to correctly scroll use `scrollToSource(...)` instead.
    /// 
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the item to scroll into view.
    ///   - scrollPosition: An option that specifies where the item should be positioned when scrolling finishes.
    ///   For a list of possible values, see UICollectionView.ScrollPosition.
    ///   - animated: Specify true to animate the scrolling behavior or
    ///    false to adjust the scroll view’s visible content immediately.
    ///
    open override func scrollToItem(
        at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool
    ) {
        super.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        if scrollPosition == .centeredHorizontally {
            centeredIndexPath = indexPath
        }
    }
}

// MARK: - Should Called API in UICollectionViewDelegate

public extension VHCarrouselCollectionView {

    /// Should be called in `UICollectionViewDelegate.scrollViewWillBeginDragging(...)`
    func scrollViewWillBeginDragging() {
        localSource.scrollViewWillBeginDragging(self)
    }

    /// Should be called in `UICollectionViewDelegate.scrollViewWillEndDragging(...)`
    func scrollViewWillEndDragging(with velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        localSource.scrollViewWillEndDragging(self, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    /// Should be called in `UICollectionViewDelegate.scrollViewDidEndScrollingAnimation(...)`
    func scrollViewDidEndScrollingAnimation() {
        localSource.scrollViewDidEndScrollingAnimation(self)
    }
}

// MARK: - Public API

public extension VHCarrouselCollectionView {

    /// Scrolls the collection view contents until the specified item
    /// which multiplied with `sourceMultiplier` is visible.
    ///
    /// - Parameters:
    ///   - indexPath: The index path of the source item to scroll into view.
    ///   - animated: Specify true to animate the scrolling behavior or
    ///    false to adjust the scroll view’s visible content immediately.
    func scrollToSource(indexPath: IndexPath, animated: Bool) {
        let index: IndexPath = indexPath.shifted(for: self)
        scrollToItem(at: index, at: .centeredHorizontally, animated: animated)
    }

    /// Reloads all of the data for the collection view.
    /// - Parameter scrollToInitial: If value is true, first source item will be centered in view.
    func reloadData(scrollToInitial: Bool) {
        localSource.updateInsets()
        super.reloadData()
        if scrollToInitial {
            safeScrollToCenter(indexPath: .zero.shifted(for: self), animated: false)
        }
        if localSource.rawTotalCount <= .zero {
            centeredIndexPath = nil
        }
    }
}

// MARK: - Internal API

internal extension VHCarrouselCollectionView {

    func safeScrollToCenter(indexPath: IndexPath, animated: Bool) {
        let itemCount = localSource.collectionView(self, numberOfItemsInSection: .zero)
        guard itemCount > .zero else { return }

        if indexPath.item < .zero {
            scrollToSource(indexPath: .zero, animated: animated)
        } else if indexPath.item < itemCount {
            scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        } else {
            scrollToSource(indexPath: IndexPath(item: itemCount, section: .zero), animated: animated)
        }
    }
}

// MARK: - Private API

private extension VHCarrouselCollectionView {

    func setupUI() {
        self.flowLayout.scrollDirection = .horizontal
    }
}
