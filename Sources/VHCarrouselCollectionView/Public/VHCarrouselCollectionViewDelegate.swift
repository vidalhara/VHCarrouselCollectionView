//
//  VHCarrouselCollectionViewDelegate.swift
//  CarrouselCV
//
//  Created by Vidal HARA on 27.07.2022.
//

import Foundation

/// The methods adopted by the object you use to informe centered item in a collection view.
@objc public protocol VHCarrouselCollectionViewDelegate: AnyObject {

    /// Can be used for source operations
    @objc optional func vhCarrouselView(
        _ carrouselView: VHCarrouselCollectionView, centeredSourceIndexPath sourceIndexPath: IndexPath
    )

    /// Can be used for view operations
    @objc optional func vhCarrouselView(
        _ carrouselView: VHCarrouselCollectionView, centeredIndexPath indexPath: IndexPath
    )
}
