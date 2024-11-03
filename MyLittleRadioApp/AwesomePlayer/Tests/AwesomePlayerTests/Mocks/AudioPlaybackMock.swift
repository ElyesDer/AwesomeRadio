//
//  AudioPlaybackMock.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 01/11/2024.
//

import Foundation
import Combine
import AVFoundation
import AwesomePlayer

final class AudioPlaybackMock: AudioPlayback {

    nonisolated(unsafe)
    var volume: Float = 1.0

    nonisolated(unsafe)
    var playCalled = false

    nonisolated(unsafe)
    var pauseCalled = false

    nonisolated(unsafe)
    var insertedItems: [AudioItem] = []

    nonisolated(unsafe)
    var itemsCountValue: Int {
        insertedItems.count
    }

    nonisolated(unsafe)
    var currentItem: AVPlayerItem? = nil

    init(
        volume: Float = 1,
        playCalled: Bool = false,
        pauseCalled: Bool = false,
        insertedItems: [AudioItem] = [],
        currentItem: AVPlayerItem? = nil,
        playerState: Bool = false,
        audioItem: AudioItem? = nil ,
        playingItem: PlayingItem? = nil
    ) {
        self.volume = volume
        self.playCalled = playCalled
        self.pauseCalled = pauseCalled
        self.insertedItems = insertedItems
        self.currentItem = currentItem
        self.playerState = playerState
        self.audioItem = audioItem
        self.playingItem = playingItem

    }

    func play() async {
        playCalled = true
    }

    func pause() async {
        pauseCalled = true
    }

    func insert(_ item: AudioItem) {
        insertedItems.append(item)
    }

    func removeAllItems() {
        insertedItems.removeAll()
    }

    func itemsCount() -> Int {
        return itemsCountValue
    }

    nonisolated(unsafe)
    var advanceToNextItemCalled: Bool = false

    func advanceToNextItem() {
        if insertedItems.isEmpty == false { return }
        advanceToNextItemCalled = true
    }

    func seek(to time: CMTime) async { }

    func adjustVolume(to value: Float) async {
        volume = value
    }

    // MARK: Mocked Publisher

    nonisolated(unsafe)
    var playerState: Bool = false

    func subscribeToPlayerStatePublisher() -> AsyncPublisher<AnyPublisher<Bool, Never>> {
        Just(playerState)
            .eraseToAnyPublisher()
            .values
    }

    nonisolated(unsafe)
    var audioItem: AudioItem?

    func subscribeToPlayerCurrentItemPublisher() -> AsyncPublisher<AnyPublisher<AudioItem?, Never>> {
        Just(audioItem)
            .eraseToAnyPublisher()
            .values
    }

    nonisolated(unsafe)
    var playingItem: PlayingItem?
    func subscribeToPlayerProgress() -> AsyncPublisher<AnyPublisher<PlayingItem?, Never>> {
        Just(playingItem)
            .eraseToAnyPublisher()
            .values
    }
}
