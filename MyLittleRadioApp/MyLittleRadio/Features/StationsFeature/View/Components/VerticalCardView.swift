//
//  VerticalCardView.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 03/11/2024.
//

import Foundation
import SwiftUI

struct VerticalCardView<Content: View>: View {

    var title: String
    var subtitle: String
    var backgroundView: () -> Content

    var body: some View {
        ZStack(alignment: .bottom) {

            backgroundView()

            VStack(alignment: .leading) {
                Spacer()

                Text(subtitle)
                    .foregroundColor(.secondary)
                    .font(.subheadline)

                Text(title)
                    .bold()
                    .font(.headline)
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.5)

            }
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
        }
        .cornerRadius(10)
        .frame(
            width: 150,
            height: 200,
            alignment: .bottom
        )
    }
}

#Preview {
    VerticalCardView(
        title: "title",
        subtitle: "subtitle"
    ) {
        Color.red
    }
}
