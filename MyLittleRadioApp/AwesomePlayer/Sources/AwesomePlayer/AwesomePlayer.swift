// The Swift Programming Language
// https://docs.swift.org/swift-book

import AVFoundation
import Combine
import AsyncAlgorithms

public struct AudioItem: Sendable, Identifiable {
    public let id: UUID
    public let url: URL
}

public enum AudioPlayerState: Sendable {
    case playing
    case paused
    case idle
}

public protocol MediaPlayer: Actor {

    /// Player Status Publishers
    var audioStatusPublisher: AsyncPublisher<AnyPublisher<AudioPlayerState, Never>> { get }

    /// Plays current Item
    func play() async

    /// Plays Identified Item from Queue
    func play(item: AudioItem) async

    /// Plays next item in the Queue
    func playNext() async

    /// Pause Player
    func pause() async

    /// Reset player
    func stop() async

    /// Add Item to queue
    func addToQueue(item: AudioItem)

    /// Control
    func seekTo<T: BinaryFloatingPoint>(
        _ time: T
    ) async

    func adjustVolume<V: BinaryFloatingPoint>(
        to volume: V
    )
}

public protocol AudioRepository {
    func fetchContent<ID: Identifiable>(
        for id: ID
    ) -> URL
}
