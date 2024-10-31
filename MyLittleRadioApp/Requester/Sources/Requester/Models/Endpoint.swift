//
//  Endpoint.swift
//  Requester
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation

public struct Endpoint {
    let url: URL
    let method: HTTPMethod
    let headers: [String: String]?
    let parameters: [String: String]?
    let body: Data?
    let decoder: JSONDecoder

    public init(
        url: URL,
        method: HTTPMethod,
        headers: [String : String]? = nil,
        parameters: [String: String]? = nil,
        body: Data? = nil,
        decoder: JSONDecoder = .init()
    ) {
        self.url = url
        self.method = method
        self.headers = headers
        self.parameters = parameters
        self.body = body
        self.decoder = decoder
    }

    func makeRequest() throws(RequesterError) -> URLRequest {
        var urlComponent = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )

        urlComponent?.queryItems = parameters?.compactMap { param in
                .init(
                    name: param.key,
                    value: param.value
                )
        }

        guard let url = urlComponent?.url else {
            throw RequesterError.configuration(URLError.badURL)
        }

        var request = URLRequest(
            url: url
        )

        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        return request
    }
}
