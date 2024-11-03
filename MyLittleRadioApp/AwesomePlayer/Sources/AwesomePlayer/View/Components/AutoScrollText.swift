//
//  File.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 01/11/2024.
//
#if canImport(UIKit)
import SwiftUI

/// warning: broken with bold | need to support `NSAttributedString.Key.paragraphStyle`
@available(iOS 14, *)
public struct AutoScrollText: View {

    private var text: String
    private var font: UIFont
    private var alignment: Alignment
    private let animation: Animation
    private var computedSize: CGSize = .zero

    @State
    private var offsetValue: CGFloat = .zero

    public init(
        text: String,
        font: UIFont,
        alignment: Alignment = .leading,
        startDelay: Double,
        duration: Double
    ) {
        self.text = text
        self.font = font
        self.alignment = alignment
        self.animation = Animation
            .linear(duration: duration)
            .delay(startDelay)
            .repeatForever(autoreverses: false)
        self.computedSize = computeSize(
            of: text,
            using: font
        )
    }

    public var body : some View {
        GeometryReader { geo in
            Text(text)
                .font(.init(font))
                .frame(
                    width: computedSize.width,
                    alignment: alignment
                )
                .offset(
                    x: offsetValue
                )
                .frame(
                    maxWidth: .infinity,
                    alignment: alignment
                )
                .drawingGroup()
                .onChange(of: text, perform: { newValue in
                    offsetValue = .zero
                    let newComputedSize = computeSize(
                        of: newValue,
                        using: font
                    )
                    if geo.size.width < newComputedSize.width {
                        withAnimation(animation) {
                            offsetValue = -newComputedSize.width
                        }
                    }
                })
                .onAppear {
                    offsetValue = .zero
                    if geo.size.width < computedSize.width {
                        withAnimation(animation) {
                            offsetValue = -computedSize.width
                        }
                    }
                }
        }
        .frame(
            height: computedSize.height
        )
    }

    private func computeSize(
        of string: String,
        using font: UIFont
    ) -> CGSize {
        let fontAttributes = [
            NSAttributedString.Key.font: font,
        ]
        let size = string.size(withAttributes: fontAttributes)
        return size
    }
}

#Preview {
    VStack {
        AutoScrollText(
            text: "Very Very Long Text",
            font: .systemFont(ofSize: 32),
            startDelay: 2,
            duration: 5
        )
    }
    .padding()
    .frame(
        maxWidth: .infinity
    )
}

#endif
