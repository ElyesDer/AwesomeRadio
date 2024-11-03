//
//  AppContainer.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
import ComposableArchitecture
import AwesomePlayer

// Handle Player and Global State
@Reducer
struct AppContainer {

    enum Tab {
        case stations, settings
    }

    @ObservableState
    struct State: Equatable {
        var currentTab: Tab = .stations
        var stations: StationsFeature.State = .init()

        // Player should be SharedState
        // remove this mock
        var awesomePlayer: AwesomePlayer.State = .init(
            playingList: [ AudioItem(
                id: .init(),
                url: URL(
                    string: "https://icecast.radiofrance.fr/franceinter-midfi.mp3"
                )!,
                mainLabel: "France Inter Radio Station",
                secondaryLabel: "France Inter Radio Station, Programme du matin et soir à écouter sur notre radio",
                coverURL: URL(
                    string: "https://www.radiofrance.fr/s3/cruiser-production/2022/05/480e3b05-9cd6-4fb3-aa4f-6d60964c70b7/1000x1000_squareimage_francemusique_v2.jpg"
                )!,
                primaryHexColor: "#e20134",
                isLive: false // wat is this ?
            )]
        )
    }

    @CasePathable
    enum Action {
        case stations(StationsFeature.Action)
        case selectTab(Tab)

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
            case let .selectTab(tab):
                state.currentTab = tab
                return .none

            case .stations:
                return .none

            case .awesomePlayer:
                return .none
            }
        }
    }
}
