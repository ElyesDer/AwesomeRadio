//
//  View+popEffect.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 01/11/2024.
//

import SwiftUI

extension View {
    @ViewBuilder
    func popEffect(
        scale: CGFloat = 1.1,
        blurEffect: CGFloat = 50
    ) -> some View {
        modifier(
            PopBlurEffectModifier(
                scale: scale,
                blurEffect: blurEffect
            )
        )
    }
}

fileprivate struct PopBlurEffectModifier: ViewModifier {
    var scale: CGFloat
    var blurEffect: CGFloat
    func body(
        content: Content
    ) -> some View {
        ZStack {
            content
                .scaleEffect(scale)
                .blur(radius: blurEffect)

            content
        }
    }
}

#Preview {
    Image(
        systemName: "music.note"
    )
    .resizable()
    .background(Color.yellow)
    .clipShape(
        RoundedRectangle(
            cornerRadius: 15,
            style: .continuous
        )
    )
    .popEffect()
    .frame(height: 250)
    .padding()
}
