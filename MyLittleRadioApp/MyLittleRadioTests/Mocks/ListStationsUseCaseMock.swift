//
//  ListStationsUseCaseMock.swift
//  MyLittleRadioTests
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
import Domain

struct ListStationsUseCaseMock: ListStationsUseCase {

    let stations: [Station]
    let error: ListStationsUseCaseError?

    init(
        stations: [Station]
    ) {
        self.stations = stations
        error = nil
    }

    init(
        error: ListStationsUseCaseError?
    ) {
        self.error = error
        self.stations = []
    }

    func execute() async throws(ListStationsUseCaseError) -> [Station] {
        if let error {
            throw error
        }
        return stations
    }
}
