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
                    VStack(alignment: .leading) {
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
                            BodyView()
                        }
                        /// Warning: iOS16.4 Support only
                        .refreshable {
                            store.send(.onRefresh)
                        }
                    }
                    .padding(4)
                }
                .navigationTitle("Morning")
                .navigationBarTitleDisplayMode(.large)
                .task {
                    store.send(
                        .onAppear
                    )
                }
            } destination: { store in
                WithPerceptionTracking {
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

    @ViewBuilder
    private func BodyView() -> some View {
        VStack(alignment: .leading) {
            LazyVStack(alignment: .center) {
                WithPerceptionTracking {
                    ForEach(
                        store.scope(
                            state: \.feed,
                            action: \.stations
                        )
                    ) { store in
                        WithPerceptionTracking {
                            StationCardView(
                                store: store
                            )
                        }
                    }
                }
            }
            .padding()
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
