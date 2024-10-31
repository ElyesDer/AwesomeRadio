//
//  StationsFeatureTests.swift
//  MyLittleRadioTests
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Testing
import ComposableArchitecture
import Domain
import Dependencies
@testable
import MyLittleRadio

@MainActor
@Suite("Station Feature Test Suite")
struct StationsFeatureTests {

    func makeStore(
        stations: [Station] = [],
        listStationUseCase: ListStationsUseCase = ListStationsUseCaseMock(
            stations: []
        )
    ) -> TestStoreOf<StationsFeature> {
        TestStore(
            initialState: StationsFeature.State.init(
                stations: IdentifiedArrayOf(
                    uniqueElements: stations.map {
                        StationDetails.State.init(
                            station: $0
                        )
                    }
                )
            )
        ) {
            StationsFeature()
        } withDependencies: {
            $0.listStationUseCase = listStationUseCase
        }
    }

    @Test("WHEN Detail Action Performed THEN Navigate To Detail")
    func navigateToDetail() async throws {

        // GIVEN

        let stations = StationStub.generate(count: 2)

        let stationStates: IdentifiedArrayOf<StationDetails.State> = IdentifiedArrayOf(
            uniqueElements: stations
                .map {
                    StationDetails.State.init(
                        station: $0
                    )
                }
        )

        let store = makeStore(
            stations: stations
        )

        // WHEN

        await store.send(.details(stationStates.first!)) {
            // THEN
            $0.path[id: 0] = .detail(
                stationStates.first!
            )
        }
    }

    @Test("WHEN onAppear THEN Fetch Radio List using UseCase")
    func storeOnInitiatedRefresh() async throws {

        // GIVEN

        let store = makeStore(
            listStationUseCase: ListStationsUseCaseMock(
                stations: []
            )
        )

        // WHEN

        await store.send(.onRefresh)

        // THEN

        await store.receive(\.fetchStations)
        await store.receive(\.setStations.success)
    }

    @Test("WHEN onAppear THEN Fetch Radio List using UseCase")
    func storeOnAppearHandler() async throws {

        // GIVEN

        let store = makeStore(
            listStationUseCase: ListStationsUseCaseMock(
                stations: []
            )
        )

        // WHEN

        await store.send(.onAppear)

        // THEN

        await store.receive(\.fetchStations)
        await store.receive(\.setStations.success)
    }

    @Test("WHEN onAppear And Fetch Radio List with Error THEN Handle Error")
    func storeOnAppearRefreshWithErrorHandler() async throws {

        // GIVEN

        let store = makeStore(
            listStationUseCase: ListStationsUseCaseMock(
                error: ListStationsUseCaseError.unableToLoadData
            )
        )

        // WHEN

        await store.send(.onAppear)

        // THEN

        await store.receive(\.fetchStations)
        await store.receive(\.setStations.failure) {
            $0.viewState = .error("Unable To Load Data")
        }
    }
}
