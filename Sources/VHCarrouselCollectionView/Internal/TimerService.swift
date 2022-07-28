//
//  TimerService.swift
//  
//
//  Created by Vidal HARA on 27.07.2022.
//

import UIKit

final class TimerService {

    var isActive = false {
        didSet {
            if isActive {
                startIfNeeded()
            } else {
                stopSoftly()
            }
        }
    }
    var action: (Bool) -> Void = { _ in }

    private var interval: TimeInterval = 3
    private var animated: Bool = true
    private var timer: Timer?

    private var isNeeded = false
    private var isPausedForAppBackground = false

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(TimerService.appEnteredToBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(TimerService.appWillEnterToForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    func setup(interval: TimeInterval, animated: Bool) {
        stopSoftly()
        self.interval = interval
        self.animated = animated
        startIfNeeded()
    }

    func stopSoftly() {
        timer?.invalidate()
        timer = nil
    }

    func startIfNeeded() {
        guard isNeeded else { return }
        start()
    }

    func configure(for window: UIWindow?) {
        if window != nil {
            startIfNeeded()
        } else {
            stopSoftly()
        }
    }

    func configure(for sourceCount: Int) {
        if sourceCount > 1 {
            start()
        } else {
            stop()
        }
    }

    func restartIfNeeded() {
        guard isNeeded else { return }
        start()
    }

    private func start() {
        stop()
        isNeeded = true
        if isActive {
            let animated = self.animated
            timer = .scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
                self?.action(animated)
            }
        }
    }

    private func stop() {
        isNeeded = false
        stopSoftly()
    }

    @objc
    private func appEnteredToBackground() {
        guard isNeeded && timer != nil else { return }
        isPausedForAppBackground = true
        stopSoftly()
    }

    @objc
    private func appWillEnterToForeground() {
        guard isPausedForAppBackground else { return }
        isPausedForAppBackground = false
        startIfNeeded()
    }

    deinit {
        stop()
        NotificationCenter.default.removeObserver(self)
    }
}
