// Copyright © Radio France. All rights reserved.

import Dependencies
import DependenciesMacros
import Domain

@DependencyClient
struct ApiClient: Sendable {

    var fetchStations: @Sendable () async throws -> [Station] = { [] }
}
