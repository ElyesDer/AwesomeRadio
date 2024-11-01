//
//  AudioPlayback.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 01/11/2024.
//

import Foundation
import AVFoundation

public protocol AudioPlayback: Sendable {

    var volume: Float { get set }

    func play() async
    func pause() async

    func insert(
        _ item: AudioItem
    )
    func removeAllItems()
    func itemsCount() -> Int
    func advanceToNextItem()
    func seek(to time: CMTime) async
    func adjustVolume(to value: Float) async
}
