//
//  RequestSessionMock.swift
//  Requester
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation

@testable
import Requester

struct RequestSessionMock: RequestSession {
    public enum Mode {
        case error(Error)
        case data(Data, URLResponse)
    }

    public var mode: Mode

    public init(mode: Mode) {
        self.mode = mode
    }

    public func data(
        for _: URLRequest
    ) async throws -> (Data, URLResponse) {
        switch mode {
        case let .data(data, response):
            return (data, response)
        case let .error(error):
            throw error
        }
    }
}
