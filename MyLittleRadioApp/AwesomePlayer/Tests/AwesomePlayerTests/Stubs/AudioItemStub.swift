//
//  AudioItemStub.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 02/11/2024.
//

import Foundation
import AwesomePlayer

enum AudioItemStub {

    static func generate(n: Int) -> [AudioItem] {
        var container: [AudioItem] = []
        for i in 1...n {
            container.append(
                AudioItemStub.generate()
            )
        }
        return container
    }

    static func generate(
        id: String = UUID().uuidString,
        streamUrl: URL = URL(string: "http://")!,
        mainLabel: String = "mainLabel",
        secondaryLabel: String = "secondaryLabel",
        coverURL: URL = URL(string: "http://")!,
        primaryHexColor: String = "",
        isTimeShiftable: Bool = Bool.random()
    ) -> AudioItem {
        AudioItem(
            id: id,
            streamUrl: streamUrl,
            mainLabel: mainLabel,
            secondaryLabel: secondaryLabel,
            coverURL: coverURL,
            primaryHexColor: primaryHexColor,
            isTimeShiftable: isTimeShiftable
        )
    }
}
