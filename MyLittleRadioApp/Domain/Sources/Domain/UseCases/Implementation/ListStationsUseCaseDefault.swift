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

    func execute() async throws(ListStationsUseCaseError) -> [Station] {
        do {
            return try await stationRepository.fetchStations()
        } catch {
            // compute logic
            throw ListStationsUseCaseError.unableToLoadData
        }
    }
}
