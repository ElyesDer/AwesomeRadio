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
        id: UUID = UUID(),
        url: URL = URL(string: "http://")!,
        mainLabel: String = "mainLabel",
        secondaryLabel: String = "secondaryLabel",
        coverURL: URL = URL(string: "http://")!,
        primaryHexColor: String = "",
        isLive: Bool = Bool.random()
    ) -> AudioItem {
        AudioItem(
            id: id,
            url: url,
            mainLabel: mainLabel,
            secondaryLabel: secondaryLabel,
            coverURL: coverURL,
            primaryHexColor: primaryHexColor,
            isLive: isLive
        )
    }
}
