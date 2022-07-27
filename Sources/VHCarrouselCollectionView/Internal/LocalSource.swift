//
//  LocalSource.swift
//  CarrouselCV
//
//  Created by Vidal HARA on 24.07.2022.
//

import UIKit

final class LocalSource: NSObject {

    private weak var collectionView: VHCarrouselCollectionView!

    weak var assignedDataSource: UICollectionViewDataSource?

    var rawTotalCount: Int {
        assignedDataSource?.collectionView(collectionView, numberOfItemsInSection: .zero) ?? .zero
    }

    var sourceMultiplier: VHCarrouselCollectionView.SourceMultiplier = .triple

    private var dataSource: UICollectionViewDataSource {
        if let assignedDataSource = assignedDataSource {
            return assignedDataSource
        }
        preconditionFailure("You should set dataSource of VHCarrouselCollectionView first")
    }

    fileprivate var visibleSourceMultiplier: VHCarrouselCollectionView.SourceMultiplier {
        rawTotalCount > 1 ? sourceMultiplier : .single
    }

    private var horizontalInset: CGFloat {
        floor((collectionView.frame.width - cellSize.width) / 2)
    }

    private var cellSize: CGSize {
        guard rawTotalCount > .zero,
              let flowDelegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
              let size = flowDelegate.collectionView?(
                collectionView, layout: collectionView.collectionViewLayout, sizeForItemAt: .zero
              )
        else { return collectionView.flowLayout.itemSize }
        return size
    }

    private var initialOffset: CGPoint = .zero
    private var initialIndexPath: IndexPath = .zero

    init(collectionView: VHCarrouselCollectionView) {
        self.collectionView = collectionView
    }

    func updateInsets() {
        collectionView.contentInset.left = horizontalInset
        collectionView.contentInset.right = collectionView.contentInset.left
    }
}

// MARK: - UIScrollViewDelegate

extension LocalSource {

    func scrollViewWillBeginDragging(_ collectionView: VHCarrouselCollectionView) {
        var normalOffset = collectionView.contentOffset
        normalOffset.x += collectionView.frame.width / 2
        if let indexPath = collectionView.indexPathForItem(at: normalOffset) {
            initialOffset = collectionView.contentOffset
            initialIndexPath = indexPath
        } else {
            initialOffset = .zero
            initialIndexPath = .zero
        }
    }

    func scrollViewWillEndDragging(
        _ collectionView: VHCarrouselCollectionView,
        withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let pointee = targetContentOffset.pointee
        targetContentOffset.pointee = collectionView.contentOffset

        let normalizedX = max(0, pointee.x + horizontalInset)
        let divider = cellSize.width + (collectionView.flowLayout.minimumLineSpacing)
        let itemIndex = Int((normalizedX / divider).rounded())

        if velocity.x == .zero {
            collectionView.safeScrollToCenter(indexPath: .init(item: itemIndex, section: .zero), animated: true)
            return
        }
        let addition = initialIndexPath.item > itemIndex ? -1 : 1
        collectionView.safeScrollToCenter(
            indexPath: .init(item: initialIndexPath.item + addition, section: .zero), animated: true
        )
    }

    func scrollViewDidEndScrollingAnimation(_ collectionView: VHCarrouselCollectionView) {
        var normalOffset = collectionView.contentOffset
        normalOffset.x += collectionView.frame.width / 2
        if let indexPath = collectionView.indexPathForItem(at: normalOffset) {
            let newIndexPath = indexPath.shifted(for: collectionView)
            if newIndexPath != collectionView.centeredIndexPath {
                collectionView.safeScrollToCenter(indexPath: newIndexPath, animated: false)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension LocalSource: UICollectionViewDataSource {

    // MARK: - Used functions
    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        return rawTotalCount * visibleSourceMultiplier.int
    }

    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        return dataSource.collectionView(collectionView, cellForItemAt: indexPath)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    // MARK: - Funneled functions
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return dataSource.collectionView?(collectionView, canMoveItemAt: indexPath) ?? false
    }

    func collectionView(
        _ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath
    ) {
        dataSource.collectionView?(collectionView, moveItemAt: sourceIndexPath, to: destinationIndexPath)
    }

    @available(iOS 14.0, *)
    func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return dataSource.indexTitles?(for: collectionView)
    }

    @available(iOS 14.0, *)
    func collectionView(
        _ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int
    ) -> IndexPath {
        dataSource.collectionView?(collectionView, indexPathForIndexTitle: title, at: index) ?? .zero
    }
}

// MARK: - Extensions

internal extension IndexPath {

    func shifted(for collectionView: VHCarrouselCollectionView) -> IndexPath {
        let rawTotalCount = collectionView.localSource.rawTotalCount

        let multiplier = collectionView.localSource.visibleSourceMultiplier
        switch multiplier {
        case .single:
            return self
        case .triple, .custom:
            return .init(
                item: (item % rawTotalCount) + (rawTotalCount * Int(CGFloat(multiplier.int) / 2)),
                section: section
            )
        }
    }
}
