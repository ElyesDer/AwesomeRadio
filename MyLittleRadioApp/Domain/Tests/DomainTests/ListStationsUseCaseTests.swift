import Testing
import Foundation
@testable import Domain

@Suite("Station Usecase Test Suite")
struct ListStationsUseCaseTests {

    @Test("GIVEN Error Fetch THEN THROWS Response")
    func testGetThrownError() async throws {
        // GIVEN

        let repository: StationRepositoryMock = .init(error: NSError())
        let sut: ListStationsUseCaseDefault = .init(
            stationRepository: repository
        )

        // WHEN - THEN

        await #expect(
            throws: NSError.self,
            performing: {
                try await sut.execute()
            }
        )
    }

    @Test("GIVEN Successful Fetch THEN Returns Response")
    func testGetSucessfullResult() async throws {
        // GIVEN

        let repository: StationRepositoryMock = .init(data: [])
        let sut: ListStationsUseCaseDefault = .init(
            stationRepository: repository
        )

        // WHEN
        let stations = try await sut.execute()

        // THEN
        #expect(stations.isEmpty)
    }
}
