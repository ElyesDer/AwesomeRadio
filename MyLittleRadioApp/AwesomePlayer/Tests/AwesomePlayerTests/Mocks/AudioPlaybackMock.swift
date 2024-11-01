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
    var itemsCountValue: Int = 0

    init(
        volume: Float = 1,
        playCalled: Bool = false,
        pauseCalled: Bool = false,
        insertedItems: [AudioItem] = []
    ) {
        self.volume = volume
        self.playCalled = playCalled
        self.pauseCalled = pauseCalled
        self.insertedItems = insertedItems
        self.itemsCountValue = insertedItems.count
    }

    func play() async {
        playCalled = true
    }

    func pause() async {
        pauseCalled = true
    }

    func insert(_ item: AudioItem) {
        insertedItems.append(item)
        itemsCountValue += 1
    }

    func removeAllItems() {
        insertedItems.removeAll()
        itemsCountValue = 0
    }

    func itemsCount() -> Int {
        return itemsCountValue
    }

    func advanceToNextItem() {
        if !insertedItems.isEmpty {
            insertedItems.removeFirst()
            itemsCountValue -= 1
        }
    }

    func seek(to time: CMTime) async {

    }

    func adjustVolume(to value: Float) async {
        volume = value
    }
}
