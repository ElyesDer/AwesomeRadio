//
//  File.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 01/11/2024.
//

import Foundation
import AVFoundation

public actor AVPlayerPlayback: AudioPlayer {
    private var player: AVPlayer?

    public init() {}

    public func play() async {
        await player?.play()
    }

    public func pause() async {
        await player?.pause()
    }

    public func stop() async {
        await player?.pause()
        player?.replaceCurrentItem(
            with: nil
        )
    }
}

public class AudioQueueManager: PlayerQueue {
    private var queue: [URL] = []
    private var currentIndex: Int = 0

    public init() {}

    public func addToQueue(url: URL) {
        queue.append(url)
    }

    public func playNext() {
        guard currentIndex + 1 < queue.count else { return }
        currentIndex += 1
        // Logic to load the next URL for playback
    }

    public func resetQueue() {
        queue.removeAll()
        currentIndex = 0
    }
}
