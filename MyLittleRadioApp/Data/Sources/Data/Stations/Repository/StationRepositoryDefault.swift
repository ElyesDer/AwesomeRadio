//
//  StationRepository.swift
//  Data
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
import Domain

struct StationRepositoryDefault: StationRepository {

    private let remoteDatasource: StationDatasource

    init(
        remoteDatasource: StationDatasource
    ) {
        self.remoteDatasource = remoteDatasource
    }

    func fetchStations() async throws -> [Station] {
        try await remoteDatasource
            .fetchStations()
            .map {
                $0.toModel()
            }
    }
}
