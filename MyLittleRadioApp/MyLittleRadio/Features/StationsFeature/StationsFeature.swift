// Copyright © Radio France. All rights reserved.

import ComposableArchitecture
import Domain

enum StationStoreError: Error, Equatable {
    case unableToLoadData
    case unknown
}

@Reducer
struct StationsFeature {

    @ObservableState
    struct State: Equatable {
        var stations: [Station] = []
        var error: StationStoreError?
    }

    @CasePathable
    enum Action {

        // MARK: ViewLifecycle

        case onAppear

        // MARK: Action Store

        case fetchStations
        case setStations(Result<[Station], StationStoreError>)
    }

    // MARK: - Dependencies

    @Dependency(\.apiClient)
    private var apiClient

    @Dependency(\.listStationUseCase)
    private var listStationUseCase

    // MARK: - Cancellable

    enum Cancellable: CaseIterable {
        case sessionFetchIdentifiable
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {

                // MARK: ViewLifecycle

            case .onAppear:
                return .send(.fetchStations)

                // MARK: Action Store

            case .fetchStations:
                return loadStations()

            case let .setStations(.success(stations)):
                state.stations = stations
                return .none

                // MARK: Error Handling

            case .setStations(.failure):
                // handle error
                return .none
            }
        }
    }

    // MARK: Private helpers

    private func loadStations() -> Effect<Action> {
        .run { send in
            await send(
                .setStations(
                    Result {
                        try await listStationUseCase.execute()
                    }.mapError(
                        mapErrors
                    )
                )
            )
        }
        .cancellable(
            id: Cancellable.sessionFetchIdentifiable,
            cancelInFlight: true
        )
    }

    private func mapErrors(_ error: Error) -> StationStoreError {
        switch error {
        case is ListStationsUseCaseError:
            return .unableToLoadData
        default:
            return .unknown
        }
    }
}
