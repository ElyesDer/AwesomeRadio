//
//  AVFRQueuePlayer.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 01/11/2024.
//

import Foundation
import AVFoundation

public final class AVFRQueuePlayer: AVQueuePlayer, AudioPlayback {

    nonisolated
    public func insert(_ item: AudioItem) {
        super.insert(
            item.getAVPlayerItem(),
            after: items().last
        )
    }

    nonisolated
    public func itemsCount() -> Int {
        super.items().count
    }

    public func adjustVolume(to value: Float) async {
        volume = value
    }
}

package extension AudioItem {
    func getAVPlayerItem() -> AVPlayerItem {
        AVPlayerItem(
            url: url
        )
    }
}
