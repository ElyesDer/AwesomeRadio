//
//  StationsMock.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
import Domain

enum StationFeatureMock {
    static var stations: [Station] {
        return [
            Station(
                id: "1",
                brandID: "brandID",
                title: "Station 1",
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
                title: "Station 2",
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
                id: "3",
                brandID: "brandID",
                title: "Station 3",
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
    }
}
