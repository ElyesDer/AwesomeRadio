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
        var stationFilter: Filters.State?

        var feed: IdentifiedArrayOf<StationDetails.State> {
            switch stationFilter?.selectedFilter {
            case .none:
                stations
            case .musical:
                stations.filter {
                    $0.station.isMusical
                }
            case .onAir:
                stations.filter {
                    $0.station.type == StationFilter.onAir.rawValue
                }
            case .timeShift:
                stations.filter {
                    $0.station.hasTimeshift
                }
            case .locale:
                stations.filter {
                    $0.station.type == StationFilter.locale.rawValue
                }
            }
        }

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
        case setStations(Result<StationMetadata, ListStationsUseCaseError>)
        case setFilters([StationFilter])

        // MARK: Navigation
        case details(StationDetails.State)
        case path(StackActionOf<Path>)

        // MARK: Features
        case stationFilter(Filters.Action)
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
                
            case let .setStations(.success(metadata)):
                state.viewState = .idle
                state.stations = IdentifiedArrayOf(
                    uniqueElements: metadata.stations.map {
                        StationDetails.State.init(station: $0)
                    }
                )
                return loadFilters(
                    with: metadata
                )

            case let .setFilters(filters):

                guard filters.isEmpty == false else {
                    state.stationFilter = nil
                    return .none
                }

                state.stationFilter = Filters.State.init(
                    filters: filters
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

                // MARK: Features

            case .stationFilter:
                return .none
            }
        }
        .forEach(
            \.path,
             action: \.path
        )
        .ifLet(\.stationFilter, action: \.stationFilter) {
            Filters()
        }
    }

    // MARK: Private helpers

    private func loadFilters(
        with metadata: StationMetadata
    ) -> Effect<Action> {

        var filters = [StationFilter]()
        metadata.metaFilters.forEach { key, value in
            if value > 0, let filter = StationFilter(rawValue: key) {
                filters.append(filter)
            }
        }

        return .send(.setFilters(filters))
    }

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
