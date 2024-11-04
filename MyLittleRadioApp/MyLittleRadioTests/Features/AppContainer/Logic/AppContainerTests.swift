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

    func makeStore(
        stations: StationsFeature.State = .init()
    ) -> TestStoreOf<AppContainer> {
        TestStore(
            initialState: AppContainer.State.init(
                stations: stations
            )
        ) {
            AppContainer()
        }
    }

    @Test("GIVEN play actioned THEN fetch State and launch Player")
    func testPlayAction() async {

        let station = StationStub.generate(
            id: "0",
            streamURL: "http://valid.com"
        )
        let stationDetails: StationDetails.State = .init(
            station: station
        )

        // GIVEN

        var path = StackState<StationsFeature.Path.State>()
        path.append(.detail(stationDetails))

        let store = makeStore(
            stations: StationsFeature.State.init(
                stations: IdentifiedArrayOf<StationDetails.State>(
                    uniqueElements: [
                        StationDetails.State.init(
                            station: station
                        )
                    ]
                ),
                path: path
            )
        )

        await store.send(.stations(.path(.element(id: 0, action: .detail(StationDetails.Action.onAppear)))))

    }

    @Test("GIVEN play actioned with invalid url THEN abandon player starting")
    func testPlayActionWithInvalidURL() async {

        let station = StationStub.generate(
            id: "0",
            streamURL: "http://valid.com"
        )
        let stationDetails: StationDetails.State = .init(
            station: station
        )

        // GIVEN

        var path = StackState<StationsFeature.Path.State>()
        path.append(.detail(stationDetails))

        let store = makeStore(
            stations: StationsFeature.State.init(
                stations: IdentifiedArrayOf<StationDetails.State>(
                    uniqueElements: [
                        StationDetails.State.init(
                            station: station
                        )
                    ]
                ),
                path: path
            )
        )

        await store.send(.stations(.path(.element(id: 0, action: .detail(StationDetails.Action.onAppear)))))

    }

}
