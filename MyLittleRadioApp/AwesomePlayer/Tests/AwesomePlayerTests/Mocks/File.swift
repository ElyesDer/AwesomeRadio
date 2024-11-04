//
//  AVAudioOutputInfoMock.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 04/11/2024.
//

import Foundation
@testable
import AwesomePlayer
import Combine

final class AVAudioOutputInfoMock: AudioOutput {

    let volume: Float

    nonisolated(unsafe)
    var deviceAudioDidChangeCalled: Bool = false

    init(
        volume: Float = 0.5
    ) {
        self.volume = volume
    }

    func deviceAudioDidChange() -> AsyncPublisher<AnyPublisher<Float, Never>> {
        deviceAudioDidChangeCalled = true
        return Just(volume)
            .eraseToAnyPublisher()
            .values
    }
}
