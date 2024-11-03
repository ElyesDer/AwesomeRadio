//
//  AVAudioSessionInfoProvider.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 03/11/2024.
//

import Foundation
import AVFoundation
import Combine

final class AVAudioSessionInfoProvider: AudioOutput, @unchecked Sendable {

    /// Publisher for the currently playing item
    private var volumePublisher: AsyncPublisher<AnyPublisher<Float, Never>> {
        volumeSubject.eraseToAnyPublisher().values
    }
    private var volumeSubject = PassthroughSubject<Float, Never>()
    private var volumeObserver: NSKeyValueObservation?

    init() {
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    deinit {
        volumeObserver?.invalidate()
    }

    func deviceAudioDidChange() -> AsyncPublisher<AnyPublisher<Float, Never>> {
        // Setup observation
        volumeObserver = AVAudioSession
            .sharedInstance()
            .observe(
                \.outputVolume,
                 options: [.initial, .new]
            ) { [weak self] _, change in
                guard let volume = change.newValue else { return }
                self?.volumeSubject.send(volume)
            }

        return volumePublisher
    }
}
