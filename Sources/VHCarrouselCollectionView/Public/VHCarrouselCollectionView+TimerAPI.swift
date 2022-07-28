//
//  VHCarrouselCollectionView+TimerAPI.swift
//  
//
//  Created by Vidal HARA on 27.07.2022.
//

import Foundation

// MARK: - Timer API

public extension VHCarrouselCollectionView {

    /// Setup timer to scroll next item in view periodically
    ///
    /// - Attention: - You should call `enableTimer()` when we is ready
    ///
    /// - Parameters:
    ///   - interval: Timer interval in seconds. Default value is 3.
    ///   - animated: Is scrolling to next item will be animated. Default value is true.
    func configureTimer(interval: TimeInterval, animated: Bool) {
        timerService.setup(interval: interval, animated: animated)
    }

    /// Enables timer to scroll next item in view periodically.
    func enableTimer() {
        timerService.isActive = true
    }

    /// Disables timer to scroll next item in view periodically.
    func disableTimer() {
        timerService.isActive = false
    }
}
