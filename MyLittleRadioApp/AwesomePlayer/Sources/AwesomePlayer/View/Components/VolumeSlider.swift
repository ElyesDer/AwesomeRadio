//
//  VolumeSlider.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 01/11/2024.
//

import Foundation
import SwiftUI

struct VolumeSlider: View {
    @Binding var progress: CGFloat
    let tint: Color

    // MARK: - Private Props

    private let inRange: ClosedRange<CGFloat> = 0...1
    @State private var computedProgress: CGFloat = 0
    @State private var tempProgress: CGFloat = 0
    @GestureState private var isActive: Bool = false

    var body: some View {
        GeometryReader { reader in

            let frameHeight = reader.size.height

            ProgressView(
                value: progress,
                total: 1
            )
            .tint(tint)
            .scaleEffect(
                y: computeScale(with: frameHeight)
            )
            .animation(
                .spring(),
                value: isActive
            )
            .frame(
                height: frameHeight,
                alignment: .center
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($isActive) { _, state, _ in
                        state = true
                    }
                    .onChanged { gesture in
                        tempProgress = gesture.translation.width / reader.size.width

                        progress = max(
                            min(
                                computeProgress(
                                    with: tempProgress
                                ), inRange.upperBound
                            ), inRange.lowerBound
                        )

                    }.onEnded { value in
                        computedProgress = max(
                            min(computedProgress + tempProgress, 1), 0
                        )
                        tempProgress = 0
                    }
            )
            .onAppear {
                computedProgress = progress
            }
        }
    }

    private func computeScale(
        with size: CGFloat
    ) -> CGFloat {
        guard size > 0 else { return 1 }
        return isActive ? size / 2.5 : size / 4
    }

    private func computeProgress(with value: CGFloat) -> CGFloat {
        let progressValue = (
            (computedProgress + value) * (inRange.upperBound - inRange.lowerBound)
        ) + inRange.lowerBound
        return progressValue
    }
}

@available(iOS 17.0, *)
@available(macOS 14.0, *)
#Preview {
    @Previewable
    @State var value: CGFloat = 0.5

    VolumeSlider(
        progress: $value,
        tint: .gray
    )
    .frame(height: 8)
    .border(Color.red)
}
