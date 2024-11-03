//
//  AppContainer.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
import ComposableArchitecture
import AwesomePlayer

@Reducer
struct AppContainer {
    @ObservableState
    struct State: Equatable {
        var stations: StationsFeature.State = .init()

        var isPlayerVisible: Bool {
            awesomePlayer.isViewable
        }

        var awesomePlayer: AwesomePlayer.State = .init()
    }

    @CasePathable
    enum Action {
        enum PlayerActionType {
            case addQueue
            case play
        }

        case stations(StationsFeature.Action)
        case awesomePlayer(AwesomePlayer.Action)
    }

    var body: some Reducer<State, Action> {

        Scope(
            state: \.awesomePlayer,
            action: \.awesomePlayer
        ) {
            AwesomePlayer()
        }

        Scope(
            state: \.stations,
            action: \.stations
        ) {
            StationsFeature()
        }

        Reduce { state, action in
            switch action {

            case let .stations(
                .path(
                    .element(
                        id: id,
                        action: StationsFeature.Path.Action.detail(StationDetails.Action.addToQueue)
                    )
                )
            ):

                guard let selectedState = state.stations.path[id: id, case: \.detail] else {
                    return .none
                }

                return handlePlayerAction(
                    action: Action.PlayerActionType.addQueue,
                    using: selectedState
                )

            case let .stations(
                .path(
                    .element(
                        id: id,
                        action: StationsFeature.Path.Action.detail(StationDetails.Action.play)
                    )
                )
            ):

                guard let selectedState = state.stations.path[id: id, case: \.detail] else {
                    return .none
                }

                return handlePlayerAction(
                    action: Action.PlayerActionType.play,
                    using: selectedState
                )

            case let .stations(
                .stations(
                    .element(
                        id: id,
                        action: StationDetails.Action.addToQueue
                    )
                )
            ):

                guard let selectedState: StationDetails.State = state.stations.stations[id: id] else {
                    return .none
                }

                return handlePlayerAction(
                    action: Action.PlayerActionType.addQueue,
                    using: selectedState
                )

            case let .stations(
                .stations(
                    .element(
                        id: id,
                        action: StationDetails.Action.play
                    )
                )
            ):
                guard let selectedState: StationDetails.State = state.stations.stations[id: id] else {
                    return .none
                }

                return handlePlayerAction(
                    action: Action.PlayerActionType.play,
                    using: selectedState
                )

            case .stations:
                return .none

            case .awesomePlayer:
                return .none
            }
        }
    }

    private func handlePlayerAction(
        action: Action.PlayerActionType,
        using selectedState: StationDetails.State
    ) -> Effect<Action> {

        guard let streamURL: URL = URL(
            string: selectedState.station.streamURL
        ) else {
            return .none
        }

        // instantiate Audio Item
        let audioItem: AudioItem = .init(
            id: selectedState.id,
            streamUrl: streamURL,
            mainLabel: selectedState.station.title,
            secondaryLabel: selectedState.station.shortTitle,
            coverURL: .init(
                string: selectedState.station.squareImageURL ?? ""
            ),
            primaryHexColor: selectedState.station.primaryColor,
            isTimeShiftable: selectedState.station.hasTimeshift
        )

        switch action {
        case .addQueue:
            return .send(
                .awesomePlayer(
                    AwesomePlayer.Action.addToQueue(
                        audioItem
                    )
                )
            )
        case .play:
            return .send(
                .awesomePlayer(
                    AwesomePlayer.Action.play(
                        audioItem
                    )
                )
            )
        }
    }
}
