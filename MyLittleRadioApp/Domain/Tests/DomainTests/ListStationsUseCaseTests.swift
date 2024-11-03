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

    @Test("GIVEN Successful Fetch THEN Parse Metadata and Stations")
    func testGetSuccessfulResult() async throws {
        // GIVEN

        let repository: StationRepositoryMock = .init(
            data: [
                StationMock.generate(
                    hasTimeshift: true,
                    type: "on_air",
                    isMusical: true
                ),
                StationMock.generate(
                    hasTimeshift: false,
                    type: "on_air",
                    isMusical: false
                )
            ]
        )
        let sut: ListStationsUseCaseDefault = .init(
            stationRepository: repository
        )

        // WHEN
        let metadata = try await sut.execute()

        // THEN
        #expect(metadata.stations.count == 2)
        #expect(metadata.metaFilters["timeshift"] == 1)
        #expect(metadata.metaFilters["musical"] == 1)
        #expect(metadata.metaFilters["on_air"] == 2)
    }
}
