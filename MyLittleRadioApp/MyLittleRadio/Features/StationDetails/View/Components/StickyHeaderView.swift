//
//  StickyHeaderView.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 03/11/2024.
//

import Foundation
import SwiftUI

struct StickyHeaderContainer<Content: View, Background: View>: View {

    var minHeight: CGFloat
    var offset: CGFloat
    var content: Content
    var background: Background

    init(
        minHeight: CGFloat = 200,
        offset: CGFloat = 0,
        @ViewBuilder content: () -> Content,
        @ViewBuilder background: () -> Background
    ) {
        self.minHeight = minHeight
        self.offset = offset
        self.content = content()
        self.background = background()
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            GeometryReader { geo in
                if(geo.frame(in: .global).minY <= 0) {
                    background
                        .frame(
                            width: geo.size.width,
                            height: geo.size.height,
                            alignment: .center
                        )
                } else {
                    background
                        .offset(y: -geo.frame(in: .global).minY)
                        .frame(
                            width: geo.size.width,
                            height: geo.size.height + geo.frame(in: .global).minY
                        )
                }
            }
            .frame(minHeight: minHeight)

            content
                .offset(y: offset)
        }
    }
}
