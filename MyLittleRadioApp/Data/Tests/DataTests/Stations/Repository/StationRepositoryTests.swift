import Testing
@testable import Data

@Suite("Station Repository Test Suite")
struct StationRepositoryTests {

    @Test("WHEN data source returns data THEN Map Models")
    func dataDomainMapping() async throws {

        // GIVEN

        let stationDatasource: StationDatasourceMock = .init(
            data: []
        )

        let sut = StationRepositoryDefault(
            remoteDatasource: stationDatasource
        )

        // WHEN

        let stations = try await sut.fetchStations()

        // THEN

        #expect(stations.isEmpty)
    }
}
