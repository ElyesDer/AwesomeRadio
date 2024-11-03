//
//  StationRow.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 03/11/2024.
//

import SwiftUI

struct StationRow: View {

    let audioItem: AudioItem

    var body: some View {
        HStack(spacing: 2) {
            AsyncImage(
                url: audioItem.coverURL,
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                },
                placeholder: {
                    Image(
                        systemName: "music.note.list"
                    )
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .padding(6)
                })
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 8,
                    style: .continuous
                )
            )
            .frame(
                width: 40,
                height: 40,
                alignment: .center
            )
            .padding(.horizontal, 8)

            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                Text(audioItem.mainLabel)
                    .font(.title3)
                    .foregroundStyle(.primary)

                Text(audioItem.secondaryLabel)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    StationRow(
        audioItem: .init(
            id: .init(),
            streamUrl: URL(
                string:
                    "https://icecast.radiofrance.fr/franceinter-midfi.mp3"
            )!,
            mainLabel: "France Inter Radio Station",
            secondaryLabel: "France Inter Radio Station, Programme du matin et soir à écouter sur notre radio",
            coverURL: URL(
                string:
                    "https://www.radiofrance.fr/s3/cruiser-production/2022/05/480e3b05-9cd6-4fb3-aa4f-6d60964c70b7/1000x1000_squareimage_francemusique_v2.jpg"
            )!,
            primaryHexColor: "#e20134",
            isTimeShiftable: false
        )
    )
}
