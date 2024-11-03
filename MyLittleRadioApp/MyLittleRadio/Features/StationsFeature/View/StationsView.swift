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
        WithPerceptionTracking {
            NavigationStack(
                path: $store.scope(
                    state: \.path,
                    action: \.path
                )
            ) {
                WithPerceptionTracking {
                    VStack {
                        if let store = store.scope(
                            state: \.stationFilter,
                            action: \.stationFilter
                        ) {
                            FilterView(
                                store: store
                            )
                            .frame(height: 40)
                        }

                        ScrollView {
                            LazyVStack(alignment: .leading) {
                                WithPerceptionTracking {
                                    ForEach(store.feed) { station in
                                        WithPerceptionTracking {
                                            Text("station.title")
                                                .onTapGesture {
                                                    store.send(.details(station))
                                                }
                                        }
                                    }
                                }
                            }
                        }
                        /// Warning: iOS16.4 Support only
                        .refreshable {
                            store.send(.onRefresh)
                        }
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
