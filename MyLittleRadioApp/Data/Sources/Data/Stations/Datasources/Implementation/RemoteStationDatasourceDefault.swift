//
//  RemoteStationDatasourceDefault.swift
//  Data
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
import Requester

struct RemoteStationDatasourceDefault: StationDatasource {

    private let apiClient: Requester

    init(
        apiClient: Requester
    ) {
        self.apiClient = apiClient
    }

    func fetchStations() async throws -> [StationAPI] {
        try await apiClient.fetch(
            from: APIEndpoints.stations(),
            as: StationsAPI.self
        ).stations
    }
}
