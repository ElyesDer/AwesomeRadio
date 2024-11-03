//
//  StationMock.swift
//  Domain
//
//  Created by Elyes Derouiche on 03/11/2024.
//

import Foundation
import Domain

enum StationMock {
    static func generate(
        stations: [Station] = [],
        metaFilters: [String: Int] = [:]
    ) -> StationMetadata {
        StationMetadata(
            stations: stations,
            metaFilters: metaFilters
        )
    }

    static func generate(
        id: String = "id",
        brandID: String = "brandID",
        title: String = "title",
        hasTimeshift: Bool = Bool.random(),
        shortTitle: String = "shortTitle",
        type: String = "type",
        streamURL: String = "streamURL",
        liveRule: String = "liveRule",
        primaryColor: String = "primaryColor",
        isMusical: Bool = Bool.random(),
        squareImageURL: String? = "squareImageURL"
    ) -> Station {
        Station(
            id: id,
            brandID: brandID,
            title: title,
            hasTimeshift: hasTimeshift,
            shortTitle: shortTitle,
            type: type,
            streamURL: streamURL,
            liveRule: liveRule,
            primaryColor: primaryColor,
            isMusical: isMusical,
            squareImageURL: squareImageURL
        )
    }
}
