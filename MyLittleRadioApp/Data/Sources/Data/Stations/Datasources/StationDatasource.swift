//
//  StationDatasource.swift
//  Data
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation

protocol StationDatasource {
    func fetchStations() async throws -> [StationAPI]
}
