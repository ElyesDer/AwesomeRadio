// Copyright © Radio France. All rights reserved.

import SwiftUI

import ComposableArchitecture
import Dependencies

@main
struct MyLittleRadioApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                StationsView(
                    store: Store(
                        initialState: .init()) {
                            StationsFeature()
                        }
                )
            }
        }
    }
}
