//
//  AVFRQueuePlayer.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 01/11/2024.
//

import Foundation
import AVFoundation
import Combine

/// Custom AVQueuePlayer Implementation with support for observing the current audio item and playback rate.
public final class AVFRQueuePlayer: AVQueuePlayer, @preconcurrency AudioPlayback {

    // MARK: - Private Properties

    private var queuedItems = Set<AudioItem>()

    /// Publisher for the currently playing item
    private var currentItemPublisher: AsyncPublisher<AnyPublisher<AudioItem?, Never>> {
        currentPlayingItemSubject.eraseToAnyPublisher().values
    }
    private var currentPlayingItemSubject = CurrentValueSubject<AudioItem?, Never>(nil)

    /// Publisher to track if the player is currently playing
    private var isPlayingPublisher: AsyncPublisher<AnyPublisher<Bool, Never>> {
        isPlayingSubject.eraseToAnyPublisher().values
    }
    private var isPlayingSubject = CurrentValueSubject<Bool, Never>(false)

    /// Publisher Player Progression
    private var currentPlayerProgress: AsyncPublisher<AnyPublisher<PlayingItem?, Never>> {
        currentPlayerSubject.eraseToAnyPublisher().values
    }
    private var currentPlayerSubject = PassthroughSubject<PlayingItem?, Never>()

    // Observers for AVQueuePlayer
    private var currentPlayerItemObservation: NSKeyValueObservation?
    private var currentRateObservation: NSKeyValueObservation?
    private var timeObserver: Any?

    override public init() {
        try? AVAudioSession
            .sharedInstance()
            .setCategory(
                AVAudioSession.Category.playback,
                mode: AVAudioSession.Mode.default
            )
        super.init()
    }

    deinit {
        currentPlayerItemObservation?.invalidate()
        currentRateObservation?.invalidate()
    }

    // MARK: Setup Subscribers

    public func subscribeToPlayerProgress() -> AsyncPublisher<AnyPublisher<PlayingItem?, Never>> {

        let interval = CMTime(
            seconds: 0.5,
            preferredTimescale: CMTimeScale(NSEC_PER_SEC)
        )

        timeObserver = addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { [weak self] time in
            Task { @MainActor in
                self?.updateCurrentPlayer(
                    progress: time
                )
            }
        }
        return currentPlayerProgress
    }

    /// Sets up observers to monitor the current item
    public func subscribeToPlayerCurrentItemPublisher() -> AsyncPublisher<AnyPublisher<AudioItem?, Never>> {
        currentPlayerItemObservation = observe(\.currentItem, options: [.new]) { [weak self] _, _ in
            Task { @MainActor in
                self?.updateCurrentItem()
            }
        }
        return currentItemPublisher
    }

    /// Sets up observers to monitor rating play item
    public func subscribeToPlayerStatePublisher() -> AsyncPublisher<AnyPublisher<Bool, Never>> {
        currentRateObservation = observe(\.rate, options: [.new]) { [weak self] _, _ in
            Task { @MainActor in
                self?.updateRate()
            }
        }
        return isPlayingPublisher
    }

    // MARK: Protocol conformance

    public func insert(_ item: AudioItem) async {
        queuedItems.insert(item)
        super.insert(
            item.playerItem,
            after: items().last
        )
    }

    public func itemsCount() -> Int {
        super.items().count
    }

    public func adjustVolume(to value: Float) async {
        volume = value
    }

    // MARK: - Private Methods

    private func updateCurrentPlayer(
        progress: CMTime
    ) {
        let progressInSeconds = CMTimeGetSeconds(progress)

        let duration: Double? = if let duration = currentItem?.duration, duration.isValid && duration.isNumeric {
            duration.seconds
        } else if let lastBufferedRange = currentItem?.loadedTimeRanges.last?.timeRangeValue {
            CMTimeRangeGetEnd(lastBufferedRange).seconds
        } else {
            nil
        }

        currentPlayerSubject.send(
            PlayingItem(
                duration: duration,
                current: progressInSeconds
            )
        )
    }

    private func updateCurrentItem() {
        guard let currentItemURL = (currentItem?.asset as? AVURLAsset)?.url else {
            currentPlayingItemSubject.send(nil)
            return
        }
        let foundItem = queuedItems.first { $0.streamUrl == currentItemURL }
        currentPlayingItemSubject.send(foundItem)
    }

    private func updateRate() {
        isPlayingSubject.send(rate > 0)
    }
}

fileprivate extension AudioItem {
    var playerItem: AVPlayerItem {
        return AVPlayerItem(url: streamUrl)
    }
}
