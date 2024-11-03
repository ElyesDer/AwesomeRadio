//
//  AwesomePlayer.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 01/11/2024.
//

import Foundation
import ComposableArchitecture
import Dependencies
@preconcurrency
import Combine

@Reducer
public struct AwesomePlayer {

    @Dependency(\.mediaPlayer) private var mediaPlayer

    @ObservableState
    public struct State: Equatable {

        var isExpanded: Bool
        var isWaitingListShown: Bool
        var playingList: [AudioItem]
        var volume: CGFloat
        var playerStatus: AudioPlayerState
        var progress: PlayingItem?

        var currentItem: AudioItem?
        var currentProgress: CGFloat = 0

        public init(
            isExpanded: Bool = false,
            isWaitingListShown: Bool = false,
            playingList: [AudioItem] = [],
            volume: CGFloat = 0.5,
            playerStatus: AudioPlayerState = .idle,
            progress: PlayingItem? = nil,
            currentItem: AudioItem? = nil,
            currentProgress: CGFloat = 0
        ) {
            self.isExpanded = isExpanded
            self.isWaitingListShown = isWaitingListShown
            self.playingList = playingList
            self.volume = volume
            self.playerStatus = playerStatus
            self.progress = progress
            self.currentItem = currentItem
            self.currentProgress = currentProgress
        }
    }

    @CasePathable
    public enum Action: BindableAction {

        // MARK: View LifeCycle
        case onAppear

        // MARK: Observers
        case binding(BindingAction<State>)

        // MARK: Player Action
        case play
        case playNext
        case pause
        case stop
        case addToQueue(AudioItem)
        case togglePlayer(Bool? = nil)

        // MARK: ViewState
        case togglePlayerView(Bool? = nil)
        case toggleWaitingList

        // MARK: Player Update Handler
        case playerStatusUpdate(AudioPlayerState)
        case playerProgressUpdate(PlayingItem?)
        case playerCurrentItemUpdate(AudioItem?)
    }

    // MARK: Cancellable

    enum Cancellable {
        case playerStatusSubscription
        case playerProgressStatusSubscription
        case playerCurrentItemSubscription
    }

    public init() { }

    public var body: some Reducer<State, Action> {

        BindingReducer()

        Reduce { state, action in
            switch action {
                
                // MARK: View LifeCycle
                
            case .onAppear:
                return .merge(
                    setupPlayerList(itemList: state.playingList),
                    subscribeToPlayerStatus(),
                    subscribeToPlayerProgress(),
                    subscribeToPlayerCurrentItem()
                )
                
                // MARK: Player Actions
                
            case let .togglePlayer(value):
                return .run { [mediaPlayer] _ in
                    if let value {
                        value ? await mediaPlayer.play() : await mediaPlayer.pause()
                    } else {
                        await mediaPlayer.togglePlay()
                    }
                }
                
            case .toggleWaitingList:
                state.isWaitingListShown.toggle()
                return .none
                
            case let .togglePlayerView(value):
                if let value {
                    state.isExpanded = value
                } else {
                    state.isExpanded.toggle()
                }
                return .none
                
            case .play:
                return .run { [mediaPlayer] _ in
                    await mediaPlayer.play()
                }
            case .playNext:
                return .run { [mediaPlayer] _ in
                    await mediaPlayer.playNext()
                }
            case .pause:
                return .run { [mediaPlayer] _ in
                    await mediaPlayer.pause()
                }
            case .stop:
                return .run { [mediaPlayer] _ in
                    await mediaPlayer.stop()
                }
            case let .addToQueue(audioItem):
                return .run { [mediaPlayer] _ in
                    await mediaPlayer.addToQueue(
                        item: audioItem
                    )
                }

                // MARK: Observers
                
            case let .playerStatusUpdate(status):
                state.playerStatus = status
                return .none

            case let .playerProgressUpdate(playingItem):
                state.progress = playingItem

                if let playingItem {
                    if let duration = playingItem.duration, duration > 0 {
                        state.currentProgress = playingItem.current / duration
                    } else {
                        state.currentProgress = 1
                    }
                } else {
                    state.currentProgress = 0
                }
                return .none

            case let .playerCurrentItemUpdate(audioItem):
                state.currentItem = audioItem
                return .none

            case .binding(\.volume):
                return .run { [ mediaPlayer, volume = state.volume] _ in
                    await mediaPlayer.adjustVolume(to: volume)
                }

            case .binding(\.currentProgress):
                return .run { [
                    mediaPlayer,
                    currentDuration = state.progress?.duration,
                    targetProgress = state.currentProgress
                ] _ in
                    let targetTime = (currentDuration ?? 0) * targetProgress
                    await mediaPlayer.seekTo(targetTime)
                }

            case .binding:
                return .none
            }
        }
    }

    private func setupPlayerList(
        itemList: [AudioItem]
    ) -> Effect<Action> {
        .run { [mediaPlayer, itemList] _ in
            for audioItem in itemList {
                await mediaPlayer.addToQueue(
                    item: audioItem
                )
            }
        }
    }

    // MARK: Subscription Handlers

    private func subscribeToPlayerProgress() -> Effect <Action> {
        .run { [mediaPlayer] send in
            for await playerProgress in await mediaPlayer.currentProgressPublisher {
                await send(.playerProgressUpdate(playerProgress))
            }
        }
        .cancellable(
            id: Cancellable.playerProgressStatusSubscription,
            cancelInFlight: true
        )
    }

    private func subscribeToPlayerCurrentItem() -> Effect <Action> {
        .run { [mediaPlayer] send in
            for await currentItem in await mediaPlayer.currentItemPublisher {
                await send(.playerCurrentItemUpdate(currentItem))
            }
        }
        .cancellable(
            id: Cancellable.playerCurrentItemSubscription,
            cancelInFlight: true
        )
    }

    private func subscribeToPlayerStatus() -> Effect<Action> {
        .run { [mediaPlayer] send in
            for await status in await mediaPlayer.audioStatusPublisher {
                await send(
                    .playerStatusUpdate(status)
                )
            }
        }
        .cancellable(
            id: Cancellable.playerStatusSubscription,
            cancelInFlight: true
        )
    }
}
