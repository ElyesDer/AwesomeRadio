//
//  MediaPlayer.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 01/11/2024.
//
import AVFoundation
import Combine
import AsyncAlgorithms

public struct AudioItem: Sendable, Identifiable, Hashable, Equatable {
    public let id: String
    public let streamUrl: URL
    public let mainLabel: String
    public let secondaryLabel: String
    public let coverURL: URL?
    public let primaryHexColor: String
    public let isTimeShiftable: Bool

    public init(
        id: String,
        streamUrl: URL,
        mainLabel: String,
        secondaryLabel: String,
        coverURL: URL?,
        primaryHexColor: String,
        isTimeShiftable: Bool
    ) {
        self.id = id
        self.streamUrl = streamUrl
        self.mainLabel = mainLabel
        self.secondaryLabel = secondaryLabel
        self.coverURL = coverURL
        self.primaryHexColor = primaryHexColor
        self.isTimeShiftable = isTimeShiftable
    }
}

public enum AudioPlayerState: Sendable {
    case playing
    case paused
    case idle
}

public protocol MediaPlayer: Actor {

    /// Player Status Publisher
    var audioStatusPublisher: AsyncPublisher<AnyPublisher<AudioPlayerState, Never>> { get }

    /// Player Current Progress Status Publisher
    var currentProgressPublisher: AsyncPublisher<AnyPublisher<PlayingItem?, Never>> { get }

    /// Player Current Item Publisher
    var currentItemPublisher: AsyncPublisher<AnyPublisher<AudioItem?, Never>> { get }

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
    func addToQueue(item: AudioItem) async

    /// Toggle Player
    func togglePlay() async

    /// Control
    func seekTo<T: BinaryFloatingPoint>(
        _ time: T
    ) async

    func adjustVolume<V: BinaryFloatingPoint>(
        to volume: V
    ) async
}

public extension AwesomePlayerFactory {
    static func createAwesomeMediaPlayer(
        audioPlayer: AudioPlayback = AVFRQueuePlayer()
    ) -> MediaPlayer {
        AwesomeMediaPlayer(
            audioPlayer: audioPlayer
        )
    }
}
