import Testing
import Foundation
@testable import Requester

@Suite("Requester Test Suite")
struct RequesterTests {

    @Test("WHEN response returned with 400 THEN throw error")
    func fetch_with_400_status_code() async throws {

        // GIVEN
        let endpoint: Endpoint = .init(
            url: .init(string: "/url.com/test")!,
            method: .get
        )

        let responseData: Data = try JSONEncoder().encode(5)
        let responseURL: HTTPURLResponse = .init(
            url: endpoint.url,
            statusCode: 400,
            httpVersion: "1.0",
            headerFields: nil
        )!

        let sut: NetworkRequester = NetworkRequester(
            session: RequestSessionMock(
                mode: .data(
                    responseData,
                    responseURL
                )
            )
        )

        // WHEN
        await #expect(
            throws: RequesterError.self,
            performing: {
            try await sut.fetch(
                from: endpoint,
                as: Int.self
            )
        })
    }

    @Test("WHEN response returned with 200 THEN decode and return response")
    func fetch_with_200_status_code() async throws {

        // GIVEN
        let endpoint: Endpoint = .init(
            url: .init(string: "/url.com/test")!,
            method: .get
        )

        let responseData: Data = try JSONEncoder().encode(5)
        let responseURL: HTTPURLResponse = .init(
            url: endpoint.url,
            statusCode: 200,
            httpVersion: "1.0",
            headerFields: nil
        )!

        let sut: NetworkRequester = NetworkRequester(
            session: RequestSessionMock(
                mode: .data(
                    responseData,
                    responseURL
                )
            )
        )

        // WHEN
        let response = try await sut.fetch(
            from: endpoint,
            as: Int.self
        )

        // THEN
        #expect(response == 5)
    }
}
