// Copyright © Radio France. All rights reserved.

import Foundation
import Domain

final class ApiManager {
    func fetchStations() async -> [Station] {
        let mockedData = [
            Station(
                id: "1",
                brandID: "brandID",
                title: "title",
                hasTimeshift: true,
                shortTitle: "shortTitle",
                type: "type",
                streamURL: "streamURL",
                liveRule: "liveRule",
                primaryColor: "primaryColor",
                isMusical: true,
                squareImageURL: "squareImageURL"
            ),

            Station(
                id: "2",
                brandID: "brandID",
                title: "title",
                hasTimeshift: true,
                shortTitle: "shortTitle",
                type: "type",
                streamURL: "streamURL",
                liveRule: "liveRule",
                primaryColor: "primaryColor",
                isMusical: true,
                squareImageURL: "squareImageURL"
            ),

            Station(
                id: "2",
                brandID: "brandID",
                title: "title",
                hasTimeshift: true,
                shortTitle: "shortTitle",
                type: "type",
                streamURL: "streamURL",
                liveRule: "liveRule",
                primaryColor: "primaryColor",
                isMusical: true,
                squareImageURL: "squareImageURL"
            )
        ]
        return mockedData
    }
}
