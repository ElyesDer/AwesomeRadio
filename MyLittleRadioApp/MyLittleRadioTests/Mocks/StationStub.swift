//
//  StationStub.swift
//  MyLittleRadioTests
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
import Domain

enum StationStub {
    static func generate(count: Int) -> [Station] {
        var container: [Station] = []
        for id in 1 ... count {
            container.append(
                generate(
                    id: String(id)
                )
            )
        }
        return container
    }

    static func generate(
        id: String,
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
