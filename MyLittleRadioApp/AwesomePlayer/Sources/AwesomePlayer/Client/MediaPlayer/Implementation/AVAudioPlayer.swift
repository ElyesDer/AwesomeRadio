//
//  AVAudioPlayer.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 01/11/2024.
//

import Foundation
import AVFoundation
import Combine

public actor AwesomeMediaPlayer: MediaPlayer {   

    // MARK: Public Props

    public var audioStatusPublisher: AsyncPublisher<AnyPublisher<AudioPlayerState, Never>> {
        audioStatus.eraseToAnyPublisher().values
    }

    public var currentItemPublisher: AsyncPublisher<AnyPublisher<AudioItem?, Never>> {
        currentItemSubject.eraseToAnyPublisher().values
    }

    public var currentProgressPublisher: AsyncPublisher<AnyPublisher<PlayingItem?, Never>> {
        currentProgressSubject.eraseToAnyPublisher().values
    }

    // MARK: Private Props

    private let audioStatus = CurrentValueSubject<AudioPlayerState, Never>(.idle)
    private let currentItemSubject = CurrentValueSubject<AudioItem?, Never>(nil)
    private let currentProgressSubject = PassthroughSubject<PlayingItem?, Never>()

    private var currentProgress: PlayingItem? {
        didSet {
            currentProgressSubject.send(currentProgress)
        }
    }

    private var playingItem: AudioItem? {
        didSet {
            currentItemSubject.send(playingItem)
        }
    }

    private var playerAudioStatus: AudioPlayerState = .idle {
        didSet {
            audioStatus.send(playerAudioStatus)
        }
    }

    private var audioPlayer: AudioPlayback
    private var queue = Set<AudioItem>()
    private var subscriptionTask: Task<Void, Never>?

    // MARK: Initializer / Deinit

    public init(
        audioPlayer: AudioPlayback
    ) {
        self.audioPlayer = audioPlayer
        Task {
            await setupSubscriptions()
        }
    }

    deinit {
        subscriptionTask?.cancel()
    }

    // MARK: Public Protocol Conformance

    public func play() async {
        await audioPlayer.play()
    }

    public func play(item: AudioItem) async {
        queue.removeAll()
        queue.insert(item)
        audioPlayer.removeAllItems()
        await audioPlayer.insert(
            item
        )
    }

    public func playNext() async {
        guard queue.isEmpty == false else {
            await stop()
            return
        }

        audioPlayer.advanceToNextItem()
        await play()
    }

    public func pause() async {
        await audioPlayer.pause()
    }

    public func stop() async {
        queue.removeAll()
        audioPlayer.removeAllItems()
    }

    public func addToQueue(item: AudioItem) async {
        queue.insert(item)
        await audioPlayer.insert(
            item
        )
    }

    public func togglePlay() async {
        switch self.playerAudioStatus {
        case .playing:
            await self.pause()
        case .idle, .paused:
            await self.play()
        }
    }

    public func seekTo<T: BinaryFloatingPoint>(_ time: T) async {
        let targetTime = CMTime(
            seconds: Double(time),
            preferredTimescale: 600
        )
        await audioPlayer.seek(
            to: targetTime
        )
    }

    public func adjustVolume<V: BinaryFloatingPoint>(
        to volume: V
    ) async {
        await audioPlayer.adjustVolume(to: Float(volume))
    }

    // MARK: Private helpers

    private func setupSubscriptions() {
        subscriptionTask = Task {
            await withTaskGroup(of: Void.self) { [
                subscribeToPlayerStatePublisher,
                subscribeToPlayerCurrentItemPublisher,
                subscribeToPlayerProgressPublisher
            ] taskGroup in
                taskGroup.addTask {
                    await subscribeToPlayerStatePublisher()
                }

                taskGroup.addTask {
                    await subscribeToPlayerCurrentItemPublisher()
                }

                taskGroup.addTask {
                    await subscribeToPlayerProgressPublisher()
                }
            }
        }
    }

    @MainActor
    private func subscribeToPlayerProgressPublisher() async {
        for await currentPlayerProgress in await audioPlayer.subscribeToPlayerProgress() {
            await updateCurrentProgress(currentPlayerProgress)
        }
    }

    private func updateCurrentProgress(_ progress: PlayingItem?) {
        self.currentProgress = progress
    }

    @MainActor
    private func subscribeToPlayerStatePublisher() async {
        for await currentPlayingNotification in await audioPlayer.subscribeToPlayerStatePublisher() {
            if currentPlayingNotification {
                await updateAudioStatus(to: .playing)
            } else {
                await updateAudioStatus(to: .paused)
            }
        }
    }

    @MainActor
    private func subscribeToPlayerCurrentItemPublisher() async {
        for await currentPlayingItem in await audioPlayer.subscribeToPlayerCurrentItemPublisher() {
            await updatePlayingItem(currentPlayingItem)
        }
    }

    private func updatePlayingItem(_ item: AudioItem?) {
        self.playingItem = item
    }

    private func updateAudioStatus(to state: AudioPlayerState) {
        playerAudioStatus = state
    }
}
