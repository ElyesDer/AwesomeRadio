//
//  ListStationsUseCaseMock.swift
//  MyLittleRadioTests
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
import Domain

// file dup
struct ListStationsUseCaseMock: ListStationsUseCase {
    let metadata: StationMetadata
    let error: ListStationsUseCaseError?

    init(
        stations: [Station]
    ) {
        self.metadata = .init(
            stations: stations,
            metaFilters: [:]
        )
        error = nil
    }

    init(
        metadata: StationMetadata
    ) {
        self.metadata = metadata
        error = nil
    }

    init(
        error: ListStationsUseCaseError?
    ) {
        self.error = error
        self.metadata = .init(
            stations: [],
            metaFilters: [:]
        )
    }

    func execute() async throws(ListStationsUseCaseError) -> StationMetadata {
        if let error {
            throw error
        }
        return metadata
    }
}
