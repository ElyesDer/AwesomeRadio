//
//  AppContainerView.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import SwiftUI
import ComposableArchitecture
import Dependencies

struct AppContainerView: View {

    @Perception.Bindable
    private var store: StoreOf<AppContainer>

    init(store: StoreOf<AppContainer>) {
        self.store = store
    }

    var body: some View {
        TabView(
            selection: $store.currentTab.sending(\.selectTab)
        ) {
            StationsView(
                store: Store(
                    initialState: .init()
                ) {
                    StationsFeature()
                }
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
        .safeAreaInset(edge: .bottom) {
            Text("My Player")
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
