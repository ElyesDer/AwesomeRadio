//
//  APIEndpoint+Station.swift
//  Data
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
import Requester

extension APIEndpoints {
    static func stations() throws(APIEndpointsError) -> Endpoint {
        let method: HTTPMethod = .get
        
        guard let url = URL(string: "\(baseUrl)/stations/") else {
            throw .configuration
        }

        return Endpoint(
            url: url,
            method: method
        )
    }
}
