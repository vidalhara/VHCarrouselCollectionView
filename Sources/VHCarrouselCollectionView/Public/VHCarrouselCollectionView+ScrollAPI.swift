//
//  VHCarrouselCollectionView+TimerAPI.swift
//  
//
//  Created by Vidal HARA on 27.07.2022.
//

import Foundation

// MARK: - Scroll API

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

    /// Scrolls to next item in view
    /// - Parameter animated: Scrolling animated if true. Default value is true.
    func scrollToNext(animated: Bool = true) {
        scrollToDelta(1, animated: animated)
    }

    /// Scrolls to previous item in view
    /// - Parameter animated: Scrolling animated if true. Default value is true.
    func scrollToPrevious(animated: Bool = true) {
        scrollToDelta(-1, animated: animated)
    }
}

private extension VHCarrouselCollectionView {

    func scrollToDelta(_ delta: Int, animated: Bool) {
        guard var newIndexPath: IndexPath = centeredIndexPath else { return }
        newIndexPath.item += delta
        if animated {
            safeScrollToCenter(indexPath: newIndexPath, animated: true)
        } else {
            safeScrollToCenter(indexPath: newIndexPath.shifted(for: self), animated: false)
        }
    }
}
