// Copyright © Radio France. All rights reserved.

import ComposableArchitecture
import Domain

@Reducer
struct StationsFeature {

    // MARK: - Navigation State

    @Reducer
    enum Path {
        case detail(StationDetails)
    }

    // MARK: - Main State
    
    @ObservableState
    struct State: Equatable {

        enum ViewState: Equatable {
            case error(String)
            case idle
        }

        var stations: IdentifiedArrayOf<StationDetails.State> = []
        var viewState: ViewState = .idle

        var path = StackState<Path.State>()
    }

    @CasePathable
    enum Action {

        // MARK: ViewLifecycle

        case onAppear

        // MARK: User Initiated Actions
        case onRefresh

        // MARK: Handlers

        case fetchStations
        case setStations(Result<[Station], ListStationsUseCaseError>)

        // MARK: Navigation
        case details(StationDetails.State)
        case path(StackActionOf<Path>)

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
                
                // MARK: User Initiated Actions
            case .onRefresh:
                return .send(.fetchStations)
                
                // MARK: Handlers
                
            case .fetchStations:
                return loadStations()
                
            case let .setStations(.success(stations)):
                state.viewState = .idle
                state.stations = IdentifiedArrayOf(
                    uniqueElements: stations.map {
                        StationDetails.State.init(station: $0)
                    }
                )
                return .none

                // MARK: Error Handling

            case .setStations(.failure):
                // handle error
                state.viewState = .error("Unable To Load Data")
                return .none

                // MARK: Handle Navigation

            case let .details(selectedStation):
                state.path.append(.detail(selectedStation))
                return .none

            case .path:
                return .none
            }
        }
        .forEach(
            \.path,
             action: \.path
        )
    }

    // MARK: Private helpers

    private func loadStations() -> Effect<Action> {
        .run { send in
            await send(
                .setStations(
                    Result {
                        try await listStationUseCase.execute()
                    }.mapError(mapErrors)
                )
            )
        }
        .cancellable(
            id: Cancellable.sessionFetchIdentifiable,
            cancelInFlight: true
        )
    }

    private func mapErrors(_ error: Error) -> ListStationsUseCaseError {
        switch error {
        case is ListStationsUseCaseError:
            return .unableToLoadData
        default:
            return ListStationsUseCaseError.unknown
        }
    }
}

extension StationsFeature.Path.State: Equatable {}
