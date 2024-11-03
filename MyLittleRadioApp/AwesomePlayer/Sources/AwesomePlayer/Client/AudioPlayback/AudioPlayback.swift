//
//  AudioPlayback.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 01/11/2024.
//

import Foundation
import AVFoundation
import Combine

public struct PlayingItem: Sendable, Equatable {
    public var duration: Double?
    public var current: Double = 0
}

public protocol AudioPlayback: Sendable {
    
    func play() async
    func pause() async

    func insert(
        _ item: AudioItem
    ) async

    func removeAllItems()
    func itemsCount() -> Int
    func advanceToNextItem()
    func seek(to time: CMTime) async
    func adjustVolume(to value: Float) async

    func subscribeToPlayerStatePublisher() -> AsyncPublisher<AnyPublisher<Bool, Never>>
    func subscribeToPlayerCurrentItemPublisher() -> AsyncPublisher<AnyPublisher<AudioItem?, Never>>
    func subscribeToPlayerProgress() -> AsyncPublisher<AnyPublisher<PlayingItem?, Never>>
}
