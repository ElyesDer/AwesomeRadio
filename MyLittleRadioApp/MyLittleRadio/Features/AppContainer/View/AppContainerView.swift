//
//  AppContainerView.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import SwiftUI
import ComposableArchitecture
import Dependencies
import AwesomePlayer

struct AppContainerView: View {

    @Perception.Bindable
    private var store: StoreOf<AppContainer>

    init(store: StoreOf<AppContainer>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            TabView(
                selection: $store.currentTab.sending(\.selectTab)
            ) {
                WithPerceptionTracking {
                    StationsView(
                        store: store.scope(
                            state: \.stations,
                            action: \.stations
                        )
                    )
                    .tag(
                        AppContainer.Tab.stations
                    )
                    .tabItem {
                        VStack {
                            Image(systemName: "music.note.house")
                            Text("Stations")
                        }
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            WithPerceptionTracking {
                AwesomePlayerView(
                    store: store.scope(
                        state: \.awesomePlayer,
                        action: \.awesomePlayer
                    )
                )
            }
        }
    }
}

#Preview {
    AppContainerView(
        store: Store(
            initialState: AppContainer.State.init()
        ) {
            AppContainer()
        }
    )
}
