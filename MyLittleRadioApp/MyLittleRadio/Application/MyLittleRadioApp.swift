// Copyright © Radio France. All rights reserved.

import SwiftUI
import ComposableArchitecture

@main
struct MyLittleRadioApp: App {
    var body: some Scene {
        WindowGroup {
            AppContainerView(
                store: Store(
                    initialState: .init()
                ) {
                    AppContainer()
                }
            )
        }
    }
}
