//
//  StationRepositoryMock.swift
//  Domain
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
@testable
import Domain

struct StationRepositoryMock: StationRepository {

    let data: [Station]
    let error: Error?

    init(
        data: [Station]
    ) {
        self.data = data
        self.error = nil
    }

    init(
        error: Error
    ) {
        self.error = error
        self.data = []
    }

    func fetchStations() async throws -> [Station] {
        if let error {
            throw error
        }
        return data
    }
}
