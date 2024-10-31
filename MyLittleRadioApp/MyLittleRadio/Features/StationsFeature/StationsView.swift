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
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(store.stations) { station in
                        HStack(spacing: 8) {
                            Text(station.title)
                            Spacer()
                            Image(
                                systemName: "chevron.right"
                            )
                        }
                        .frame(height: 50)
                    }
                }
            }
        }
        .task {
            store.send(
                .onAppear
            )
        }
    }
}

#Preview {
    StationsView(
        store: Store(
            initialState: StationsFeature.State.init(
                stations: StationFeatureMock.stations
            )
        ) {
            StationsFeature()
        }
    )
}
