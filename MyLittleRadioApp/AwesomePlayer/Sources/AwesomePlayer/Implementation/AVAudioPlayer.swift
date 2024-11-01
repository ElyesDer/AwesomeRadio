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

    // MARK: Private Props

    private var audioPlayer: AudioPlayback
    private let audioStatus = CurrentValueSubject<AudioPlayerState, Never>(.idle)

    public init(
        audioPlayer: AudioPlayback
    ) {
        self.audioPlayer = audioPlayer
    }

    public func play() async {
        await audioPlayer.play()
        audioStatus.send(.playing)
    }
    
    public func play(item: AudioItem) async {
        audioPlayer.removeAllItems()
        audioPlayer.insert(
            item
        )
        audioStatus.send(.playing)
    }
    
    public func playNext() async {
        guard audioPlayer.itemsCount() > 1 else {
            await stop()
            return
        }
        audioPlayer.advanceToNextItem()
        await play()
    }
    
    public func pause() async {
        await audioPlayer.pause()
        audioStatus.send(.paused)
    }
    
    public func stop() async {
        audioPlayer.removeAllItems()
        audioStatus.send(.idle)
    }
    
    public func addToQueue(item: AudioItem) {
        audioPlayer.insert(
            item
        )
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
    ) {
        audioPlayer.volume = Float(volume)
    }
}
