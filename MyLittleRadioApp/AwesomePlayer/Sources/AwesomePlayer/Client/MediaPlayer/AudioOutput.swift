//
//  AudioOutput.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 03/11/2024.
//

import Foundation
import Combine

protocol AudioOutput: Sendable {
    func deviceAudioDidChange() -> AsyncPublisher<AnyPublisher<Float, Never>>
}
