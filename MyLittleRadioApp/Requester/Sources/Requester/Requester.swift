// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public enum RequesterError: Error {
    case configuration(URLError.Code?)
    case decoding(any Error)
    case response(Status)
}

public protocol Requester {
    func fetch<T: Decodable>(
        from endpoint: Endpoint,
        as type: T.Type
    ) async throws(RequesterError) -> T
}
