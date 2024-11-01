//
//  AVFRQueuePlayer.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 01/11/2024.
//

import Foundation
import AVFoundation

final class AVFRQueuePlayer: AVQueuePlayer, AudioPlayback {

    nonisolated
    func insert(_ item: AudioItem) {
        super.insert(
            item.getAVPlayerItem(),
            after: items().last
        )
    }

    nonisolated
    func itemsCount() -> Int {
        super.items().count
    }

    func adjustVolume(to value: Float) async {
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
