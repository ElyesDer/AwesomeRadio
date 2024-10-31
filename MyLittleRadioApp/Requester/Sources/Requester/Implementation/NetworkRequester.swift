//
//  NetworkRequester.swift
//  Requester
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation

public struct NetworkRequester: Requester {

    private let session: RequestSession

    public init(
        session: RequestSession
    ) {
        self.session = session
    }

    public func fetch<T>(
        from endpoint: Endpoint,
        as type: T.Type
    ) async throws(RequesterError) -> T where T : Decodable {

        let request = try endpoint.makeRequest()

        // Make request

        let result: (data: Data, response: URLResponse)? = try? await session.data(
            for: request
        )

        guard let result, let response = result.response as? HTTPURLResponse else {
            throw RequesterError.response(.invalid)
        }

        let status = Status(
            from: response
        )

        guard status.isValid else {
            throw RequesterError.response(status)
        }

        // Decoding data

        do {
            let decodedValue = try endpoint.decoder.decode(
                type,
                from: result.data
            )

            return decodedValue
        } catch {
            throw RequesterError.decoding(error)
        }
    }
}
