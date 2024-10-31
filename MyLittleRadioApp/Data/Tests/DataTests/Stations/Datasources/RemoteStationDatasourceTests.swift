//
//  RemoteStationDatasourceTests.swift
//  Data
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Testing
import Foundation
import Requester
@testable import Data

@Suite("Station Datasource Test Suite")
final class RemoteStationDatasourceTests {

    var sut: RemoteStationDatasourceDefault!
    var apiClient: NetworkRequester!

    lazy var dataProvider: Data = {
        guard let url = Bundle.module.url(forResource: "stations", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            fatalError("mocked source not found")
        }
        return data
    }()

    @Test("WHEN encoding valid data returns encoded models")
    func dataEncoding() async throws {

        // GIVEN

        let responseURL: HTTPURLResponse = .init(
            url: URL.init(string: "http://link.com")!,
            statusCode: 200,
            httpVersion: "1.0",
            headerFields: nil
        )!

        apiClient = NetworkRequester(
            session: MockedRequestSession(
                mode: .data(
                    dataProvider,
                    responseURL
                )
            )
        )
        sut = .init(apiClient: apiClient)

        // WHEN

        let stations = try await sut.fetchStations()

        // THEN

        #expect(stations.count == 7)
    }
}
