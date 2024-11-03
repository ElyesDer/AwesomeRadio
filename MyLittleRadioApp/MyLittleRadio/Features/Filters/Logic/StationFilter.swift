//
//  StationFilter.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 03/11/2024.
//

import Foundation

enum StationFilter: String, CaseIterable, Hashable, Equatable {
    
    case timeShift = "timeshift"
    case onAir = "on_air"
    case musical = "musical"
    case locale = "locale"

    var description: String {
        switch self {
        case .timeShift:
            "Time Shift"
        case .onAir:
            "Live"
        case .musical:
            "Music"
        case .locale:
            "Locale"
        }
    }
}
