//
//  FiltersTests.swift
//  MyLittleRadioTests
//
//  Created by Elyes Derouiche on 03/11/2024.
//

import Testing
import ComposableArchitecture
import Dependencies
@testable
import MyLittleRadio

@MainActor
@Suite("Filters Store Tests")
struct FiltersTests {

    func makeStore(
        filters: [StationFilter],
        selectedFilter: StationFilter?
    ) -> TestStoreOf<Filters> {
        TestStore(
            initialState: Filters.State.init(
                filters: filters,
                selectedFilter: selectedFilter
            )
        ) {
            Filters()
        }
    }

    @Test("WHEN select filter while non is selected THEN Select Filter")
    func testFilterSelectBasic() async throws {
        // GIVEN

        let filterToSelect: StationFilter = .musical

        let store = makeStore(
            filters: StationFilter.allCases,
            selectedFilter: nil
        )

        // WHEN
        await store.send(.onTap(filterToSelect)) {
            // THEN
            $0.selectedFilter = filterToSelect
        }
    }

    @Test("WHEN select filter while already selected one THEN Update Filter")
    func testFilterToggleSelection() async throws {
        // GIVEN

        let selectedFilter: StationFilter = .musical

        let store = makeStore(
            filters: StationFilter.allCases,
            selectedFilter: selectedFilter
        )

        // WHEN
        await store.send(.onTap(.onAir)) {

            // THEN
            $0.selectedFilter = .onAir
        }
    }

    @Test("WHEN select filter while reselect same one THEN unselect Filter")
    func testSameFilterToggleSelection() async throws {
        // GIVEN

        let selectedFilter: StationFilter = .musical

        let store = makeStore(
            filters: StationFilter.allCases,
            selectedFilter: selectedFilter
        )

        // WHEN
        await store.send(.onTap(selectedFilter)) {

            // THEN
            $0.selectedFilter = nil
        }
    }
}
