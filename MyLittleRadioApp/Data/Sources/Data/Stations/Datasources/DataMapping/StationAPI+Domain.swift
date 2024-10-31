//
//  StationAPI+Domain.swift
//  Data
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import Foundation
import Domain

extension StationAPI {
    func toModel() -> Station {
        Station(
            id: self.id,
            brandID: self.brandID,
            title: self.title,
            hasTimeshift: self.hasTimeshift,
            shortTitle: self.shortTitle,
            type: self.type,
            streamURL: self.streamURL,
            liveRule: self.liveRule,
            primaryColor: self.colors.primary,
            isMusical: self.isMusical,
            squareImageURL: self.assets?.squareImageURL
        )
    }
}
