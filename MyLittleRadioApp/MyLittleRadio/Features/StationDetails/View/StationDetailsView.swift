//
//  StationDetailsView.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import SwiftUI
import ComposableArchitecture

struct StationDetailsView: View {

    @Perception.Bindable
    private var store: StoreOf<StationDetails>

    init(store: StoreOf<StationDetails>) {
        self.store = store
    }

    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    StationDetailsView(
        store: Store(
            initialState: StationDetails.State.init(
                station: StationFeatureMock.stations.first!
            ),
            reducer: {
                StationDetails()
            }
        )
    )
}
