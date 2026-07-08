//
//  MiniatureCard.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 03/11/2024.
//

import Foundation
import SwiftUI

struct MiniatureCardView<Content: View>: View {

    var text: String
    var color: Color
    var backgroundView: () -> Content

    var body: some View {
        ZStack {
            backgroundView()
            Text(text)
                .foregroundColor(.white)
                .font(.headline)
                .padding()
        }
        .cornerRadius(10)
        .frame(
            width: 150,
            height: 100,
            alignment: .center
        )
    }
}

#Preview {
    MiniatureCardView(
        text: "Miniature",
        color: .red
    ) {
        Color.red
    }
}
