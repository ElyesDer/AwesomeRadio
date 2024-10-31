//
//  StationDatasource.swift
//  Data
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
import Requester

public protocol StationDatasource: Sendable {
    func fetchStations() async throws -> [StationAPI]
}

public extension DataFactory {
    static func makeRemoteStationDatasource(
        requester: any Requester
    ) -> StationDatasource {
        RemoteStationDatasourceDefault(
            apiClient: requester
        )
    }
}
