//
//  ListStationsUseCaseDefault.swift
//  Domain
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation

struct ListStationsUseCaseDefault: ListStationsUseCase {

    private let stationRepository: StationRepository

    init(stationRepository: StationRepository) {
        self.stationRepository = stationRepository
    }

    func execute() async throws(ListStationsUseCaseError) -> StationMetadata {
        let stations: [Station]
        do {
            stations = try await stationRepository.fetchStations()
        } catch {
            // compute logic
            throw ListStationsUseCaseError.unableToLoadData
        }

        var metaFilters: [String: Int] = [:]
        for station in stations {
            if station.hasTimeshift {
                metaFilters["timeshift", default: 0] += 1
            }

            metaFilters[station.type, default: 0] += 1

            if station.isMusical {
                metaFilters["musical", default: 0] += 1
            }
        }

        return StationMetadata(
            stations: stations,
            metaFilters: metaFilters
        )
    }
}
