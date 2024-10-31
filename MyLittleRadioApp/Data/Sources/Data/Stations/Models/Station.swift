//
//  Station.swift
//  Domain
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation

struct StationsAPI: Codable {
    let stations: [StationAPI]
}

// MARK: - Station
struct StationAPI: Codable {
    let id, brandID, title: String
    let hasTimeshift: Bool
    let shortTitle, type: String
    let streamURL: String
    let analytics: AnalyticsAPI
    let liveRule: String
    let colors: ColorsAPI
    let isMusical: Bool
    let assets: AssetsAPI?

    enum CodingKeys: String, CodingKey {
        case id
        case brandID = "brandId"
        case title, hasTimeshift, shortTitle, type
        case streamURL = "streamUrl"
        case analytics, liveRule, colors, isMusical, assets
    }
}

// MARK: - Analytics
struct AnalyticsAPI: Codable {
    let value: String
    let stationAudienceID: Int

    enum CodingKeys: String, CodingKey {
        case value
        case stationAudienceID = "stationAudienceId"
    }
}

// MARK: - Assets
struct AssetsAPI: Codable {
    let squareImageURL: String

    enum CodingKeys: String, CodingKey {
        case squareImageURL = "squareImageUrl"
    }
}

// MARK: - Colors
struct ColorsAPI: Codable {
    let primary: String
}
