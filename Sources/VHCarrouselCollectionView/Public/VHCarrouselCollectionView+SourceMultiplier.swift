//
//  VHCarrouselCollectionView+SourceMultiplier.swift
//  CarrouselCV
//
//  Created by Vidal HARA on 24.07.2022.
//

import Foundation

// swiftlint:disable identifier_name
public extension VHCarrouselCollectionView {

    /// Source Multiplier Logic
    enum SourceMultiplier {
        /// Source will not multiplied
        case single
        /// Source will multiplied with three
        case triple
        /// Source will multiplied with custom value you entered
        case custom(Int)

        internal var int: Int {
            switch self {
            case .single:
                return 1
            case .triple:
                return 3
            case .custom(let multiplier):
                return multiplier
            }
        }
    }
}
// swiftlint:enable identifier_name
