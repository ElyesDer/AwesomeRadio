//
//  StationRepository.swift
//  Domain
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation

public protocol StationRepository: Sendable {
    func fetchStations() async throws -> [Station]
}
