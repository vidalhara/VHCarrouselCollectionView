//
//  IndexPath+Additions.swift
//  CarrouselCV
//
//  Created by Vidal HARA on 24.07.2022.
//

import UIKit

public extension IndexPath {

    /// Convert indexPath to real source indexPath
    /// - Parameter collectionView: VHCarrouselCollectionView
    /// - Returns: Real indexPath for using source
    func vhCarrouselSourceIndexPath(for collectionView: UICollectionView) -> IndexPath {
        guard let collectionView = collectionView as? VHCarrouselCollectionView else { return self }
        let rawTotalCount = collectionView.localSource.rawTotalCount
        return .init(item: item % rawTotalCount, section: section)
    }
}

internal extension IndexPath {
    static var zero: IndexPath { .init(item: .zero, section: .zero) }
}
