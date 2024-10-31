//
//  Dependencies+Domain.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
import Dependencies
import Domain
import Data

extension DependencyValues {
    private enum ListStationUseCaseKey: DependencyKey {
        static let liveValue: ListStationsUseCase = DomainFactory.makeListStationsUseCase(
            stationRepository: DataFactory.makeStationRepository(
                remoteDatasource: DataFactory.makeRemoteStationDatasource(
                    requester: Dependency(\.requester).wrappedValue
                )
            )
        )
    }

    var listStationUseCase: ListStationsUseCase {
        get { self[ListStationUseCaseKey.self] }
        set { self[ListStationUseCaseKey.self] = newValue }
    }
}
