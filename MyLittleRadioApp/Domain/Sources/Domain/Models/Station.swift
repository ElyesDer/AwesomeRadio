//
//  Station.swift
//  Domain
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation

// MARK: - Station
public struct Station: Sendable, Equatable, Identifiable {
    public let id: String
    public let brandID: String
    public let title: String
    public let hasTimeshift: Bool
    public let shortTitle: String
    public let type: String
    public let streamURL: String
    public let liveRule: String
    public let primaryColor: String
    public let isMusical: Bool
    public let squareImageURL: String?

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
