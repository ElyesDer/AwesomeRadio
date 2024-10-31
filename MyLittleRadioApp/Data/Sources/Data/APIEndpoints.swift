// The Swift Programming Language
// https://docs.swift.org/swift-book

package enum APIEndpoints {

    static let baseUrl: String = "http://localhost:3000"

    enum APIEndpointsError: Error {
        case configuration
    }
}
