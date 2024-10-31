//
//  RequestSession.swift
//  Requester
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation

public protocol RequestSession: Sendable {
    func data(
        for request: URLRequest
    ) async throws -> (Data, URLResponse)
}
