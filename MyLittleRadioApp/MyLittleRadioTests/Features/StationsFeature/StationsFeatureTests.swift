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
struct StationsFeatureTests {

    func makeStore(
        stations: [Station] = [],
        listStationUseCase: ListStationsUseCase
    ) -> TestStoreOf<StationsFeature> {
        TestStore(
            initialState: StationsFeature.State(
                stations: stations
            )
        ) {
            StationsFeature()
        } withDependencies: {
            $0.listStationUseCase = listStationUseCase
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
