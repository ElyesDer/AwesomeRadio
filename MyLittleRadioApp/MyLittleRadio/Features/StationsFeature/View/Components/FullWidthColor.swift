//
//  FullWidthCard.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 03/11/2024.
//

import SwiftUI

struct FullWidthCard<
    Content: View,
    ActionContent: View
>: View {

    var title: String
    var subtitle: String
    var BackgroundView: () -> Content
    var ActionView: () -> ActionContent

    init(
        title: String,
        subtitle: String,
        @ViewBuilder background: @escaping () -> Content,
        @ViewBuilder actionView: @escaping () -> ActionContent
    ) {
        self.title = title
        self.subtitle = subtitle
        self.BackgroundView = background
        self.ActionView = actionView
    }

    var body: some View {
        ZStack (alignment: .bottomLeading) {

            BackgroundView()

            VStack(alignment: .leading) {
                Spacer()

                HStack {
                    VStack(alignment: .leading) {
                        Text(title)
                            .foregroundColor(.white)
                            .font(.headline)

                        Text(subtitle)
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 8)

                    Spacer()

                    ActionView()

                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding(10)
                .background(
                    Color
                        .gray
                        .opacity(0.7)
                )
            }
        }
        .cornerRadius(10)
        .frame(height: 260)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    FullWidthCard(
        title: "Title",
        subtitle: "Sub title"
    ) {
        Color.red
    } actionView: {
        Image(
            systemName: "play"
        )
        .padding(.horizontal)
    }
}
