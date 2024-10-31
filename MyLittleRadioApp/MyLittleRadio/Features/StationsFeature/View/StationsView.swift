// Copyright © Radio France. All rights reserved.

import SwiftUI
import ComposableArchitecture

struct StationsView: View {

    @Perception.Bindable
    private var store: StoreOf<StationsFeature>

    init(store: StoreOf<StationsFeature>) {
        self.store = store
    }

    var body: some View {
        NavigationStack(
            path: $store.scope(
                state: \.path,
                action: \.path
            )
        ) {
            WithPerceptionTracking {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(store.stations) { station in
                            Text("Station")
                                .onTapGesture {
                                    store.send(.details(station))
                                }
                        }
                    }
                }
                /// Warning: iOS16.4 Support only
                .refreshable {
                    store.send(.onRefresh)
                }
            }
            .task {
                store.send(
                    .onAppear
                )
            }
        } destination: { store in
            switch store.case {
            case let .detail (store):
                StationDetailsView(
                    store: store
                )
            }
        }
    }
}

#Preview {
    StationsView(
        store: Store(
            initialState: StationsFeature.State.init(
                stations: IdentifiedArrayOf(
                    uniqueElements: StationFeatureMock.stations.map {
                        StationDetails.State.init(
                            station: $0
                        )
                    }
                )
            )
        ) {
            StationsFeature()
        }
    )
}
