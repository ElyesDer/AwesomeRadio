//
//  DependencyValues+MediAplayer.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 01/11/2024.
//

import Foundation

@preconcurrency
import Dependencies

extension DependencyValues {
    public var mediaPlayer: MediaPlayer {
        get { self[MediaPlayerKey.self] }
        set { self[MediaPlayerKey.self] = newValue }
    }

    private enum MediaPlayerKey: DependencyKey {
        static var liveValue: any MediaPlayer {
            AwesomeMediaPlayer(
                audioPlayer: AVFRQueuePlayer()
            )
        }
    }
}
