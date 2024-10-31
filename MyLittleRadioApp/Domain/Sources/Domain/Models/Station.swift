//
//  Station.swift
//  Domain
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation

// MARK: - Station
public struct Station: Sendable {
    let id: String
    let brandID: String
    let title: String
    let hasTimeshift: Bool
    let shortTitle: String
    let type: String
    let streamURL: String

    // Value means ?
    let liveRule: String
    let primaryColor: String
    let isMusical: Bool
    let squareImageURL: String?

    public init(
        id: String,
        brandID: String,
        title: String,
        hasTimeshift: Bool,
        shortTitle: String,
        type: String,
        streamURL: String,
        liveRule: String,
        primaryColor: String,
        isMusical: Bool,
        squareImageURL: String?
    ) {
        self.id = id
        self.brandID = brandID
        self.title = title
        self.hasTimeshift = hasTimeshift
        self.shortTitle = shortTitle
        self.type = type
        self.streamURL = streamURL
        self.liveRule = liveRule
        self.primaryColor = primaryColor
        self.isMusical = isMusical
        self.squareImageURL = squareImageURL
    }
}
