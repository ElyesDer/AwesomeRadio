//
//  Dependencies+Requester.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
import Dependencies
import Requester

extension DependencyValues {
    private enum RequesterKey: DependencyKey {
        static let liveValue: Requester = NetworkRequester(
            session: URLSession.shared
        )
    }

    public var requester: any Requester {
        get { self[RequesterKey.self] }
        set { self[RequesterKey.self] = newValue }
    }
}
