//
//  View+conditionalModifier.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 04/11/2024.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func `if`< Content: View>(
        _ value: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if value {
            transform(self)
        }
    }
}
