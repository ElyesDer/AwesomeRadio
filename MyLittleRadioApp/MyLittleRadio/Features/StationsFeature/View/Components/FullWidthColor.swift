//
//  FullWidthCard.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 03/11/2024.
//

import SwiftUI

struct FullWidthCard<Content: View>: View {

    var title: String
    var subtitle: String
    var backgroundView: () -> Content

    var body: some View {
        ZStack (alignment: .bottomLeading) {

            backgroundView()

            VStack(alignment: .leading) {
                Spacer()

                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(.white)
                        .font(.headline)

                    Text(subtitle)
                        .foregroundColor(.white)
                        .font(.subheadline)
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding(10)
                .background(
                    Color
                        .gray
                        .opacity(0.8)
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
    }
}
