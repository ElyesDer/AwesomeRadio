//
//  AppContainerTests.swift
//  MyLittleRadioTests
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
import Testing
import ComposableArchitecture
import Domain
import Dependencies
@testable
import MyLittleRadio

@MainActor
@Suite("AppContainer Test Suite")
struct AppContainerTests {

    func makeStore() -> TestStoreOf<AppContainer> {
        TestStore(
            initialState: AppContainer.State.init()
        ) {
            AppContainer()
        } withDependencies: { _ in 

        }
    }

    @Test("WHEN Tab changes THEN Update State")
    func handleTabChanges() async throws {

        // GIVEN

        let store = makeStore()

        // WHEN

        await store.send(.selectTab(.settings)) {
            // THEN
            $0.currentTab = .settings
        }
    }
}
