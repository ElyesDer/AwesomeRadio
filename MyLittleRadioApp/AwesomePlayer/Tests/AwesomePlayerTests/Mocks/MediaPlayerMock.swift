//
//  MediaPlayerMock.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 02/11/2024.
//

import Foundation
import AwesomePlayer
import Combine

final actor MediaPlayerMock: MediaPlayer {
    // MARK: - Publishers
    var playerState: AudioPlayerState = .idle
    nonisolated(unsafe)
    var audioStatusPublisherCalled: Bool = false
    var audioStatusPublisher: AsyncPublisher<AnyPublisher<AudioPlayerState, Never>> {
        get {
            audioStatusPublisherCalled = true
            return Just(playerState)
                .eraseToAnyPublisher()
                .values
        }
    }


    var playingItem: PlayingItem? = nil
    nonisolated(unsafe)
    var currentProgressPublisherCalled = false
    var currentProgressPublisher: AsyncPublisher<AnyPublisher<PlayingItem?, Never>> {
        get {
            currentProgressPublisherCalled = true
            return Just(playingItem)
                .eraseToAnyPublisher()
                .values
        }
    }

    var audioItem: AudioItem? = nil
    nonisolated(unsafe)
    var currentItemPublisherCalled = false
    var currentItemPublisher: AsyncPublisher<AnyPublisher<AudioItem?, Never>> {
        get {
            currentItemPublisherCalled = true
            return Just(audioItem)
                .eraseToAnyPublisher()
                .values

        }
    }

    // MARK: - Mocked Methods
    var playCalled = false
    func play() async {
        playCalled = true
    }

    var playItemCalled = false
    var playItemArg: AudioItem?
    func play(item: AudioItem) async {
        playItemCalled = true
        playItemArg = item
    }

    var playNextCalled = false
    func playNext() async {
        playNextCalled = true
    }

    var pauseCalled = false
    func pause() async {
        pauseCalled = true
    }

    var stopCalled = false
    func stop() async {
        stopCalled = true
    }

    var addToQueueCalled = false
    var addToQueueArg: AudioItem?
    func addToQueue(item: AudioItem) async {
        addToQueueCalled = true
        addToQueueArg = item
    }

    var togglePlayCalled = false
    func togglePlay() async {
        togglePlayCalled = true
    }

    var seekToCalled = false

    nonisolated(unsafe)
    var seekToArg: Any?

    func seekTo<T: BinaryFloatingPoint>(_ time: T) async {
        seekToCalled = true
        seekToArg = time
    }

    var adjustVolumeCalled = false
    var adjustVolumeArg: Any?
    func adjustVolume<V: BinaryFloatingPoint>(to volume: V) async {
        adjustVolumeCalled = true
        adjustVolumeArg = volume
    }

    init(
        playerState: AudioPlayerState = .idle,
        playingItem: PlayingItem? = nil,
        audioItem: AudioItem? = nil,
        playCalled: Bool = false,
        playItemCalled: Bool = false,
        playItemArg: AudioItem? = nil,
        playNextCalled: Bool = false,
        pauseCalled: Bool = false,
        stopCalled: Bool = false,
        addToQueueCalled: Bool = false,
        addToQueueArg: AudioItem? = nil,
        togglePlayCalled: Bool = false,
        seekToCalled: Bool = false,
        seekToArg: Any? = nil,
        adjustVolumeCalled: Bool = false,
        adjustVolumeArg: Any? = nil
    ) {
        self.playerState = playerState
        self.playingItem = playingItem
        self.audioItem = audioItem
        self.playCalled = playCalled
        self.playItemCalled = playItemCalled
        self.playItemArg = playItemArg
        self.playNextCalled = playNextCalled
        self.pauseCalled = pauseCalled
        self.stopCalled = stopCalled
        self.addToQueueCalled = addToQueueCalled
        self.addToQueueArg = addToQueueArg
        self.togglePlayCalled = togglePlayCalled
        self.seekToCalled = seekToCalled
        self.seekToArg = seekToArg
        self.adjustVolumeCalled = adjustVolumeCalled
        self.adjustVolumeArg = adjustVolumeArg
    }
}
