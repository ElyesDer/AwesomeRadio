//
//  File.swift
//  Data
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
@testable import Data

struct StationDatasourceMock: StationDatasource {

    let data: [StationAPI]
    let error: Error?

    init(
        data: [StationAPI]
    ) {
        self.data = data
        self.error = nil
    }

    init(
        error: Error?
    ) {
        self.data = []
        self.error = error
    }

    func fetchStations() async throws -> [StationAPI] {
        if let error {
            throw error
        }
        return data
    }
}
