//
//  ListStationsUseCaseMock.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 01/11/2024.
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
