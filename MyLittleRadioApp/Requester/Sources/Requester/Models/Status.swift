//
//  Status.swift
//  Requester
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation

public enum Status: String, Equatable, Sendable {
    case invalid
    case success

    init(
        from response: HTTPURLResponse
    ) {
        switch response.statusCode {
        case 200 ... 299:
            self = .success
        default:
            self = .invalid
        }
    }

    var isValid: Bool {
        switch self {
        case .success:
            true
        default:
            false
        }
    }
}
