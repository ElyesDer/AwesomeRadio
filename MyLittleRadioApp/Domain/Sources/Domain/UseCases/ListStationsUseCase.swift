//
//  ListStationsUseCase.swift
//  Domain
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation

public enum ListStationsUseCaseError: Error {
    case unableToLoadData
}

public protocol ListStationsUseCase: Sendable {
    func execute() async throws(ListStationsUseCaseError) -> [Station]
}

public extension DomainFactory {
    static func makeListStationsUseCase(
        stationRepository: StationRepository
    ) -> ListStationsUseCase {
        ListStationsUseCaseDefault(
            stationRepository: stationRepository
        )
    }
}
