//
//  StationMetadata.swift
//  Domain
//
//  Created by Elyes Derouiche on 03/11/2024.
//

import Foundation

public struct StationMetadata: Sendable {
    public let stations: [Station]
    public let metaFilters: [String: Int]

    public init(
        stations: [Station],
        metaFilters: [String : Int]
    ) {
        self.stations = stations
        self.metaFilters = metaFilters
    }
}
