//
//  DataFactory+init.swift
//  Data
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
import Domain

public extension DataFactory {
    static func makeStationRepository(
        remoteDatasource: StationDatasource
    ) -> StationRepository {
        StationRepositoryDefault(
            remoteDatasource: remoteDatasource
        )
    }
}
