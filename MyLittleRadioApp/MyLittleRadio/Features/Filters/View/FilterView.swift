//
//  FilterView.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 03/11/2024.
//

import SwiftUI
import ComposableArchitecture

struct FilterView: View {

    @Perception.Bindable
    private var store: StoreOf<Filters>

    init(
        store: StoreOf<Filters>
    ) {
        self.store = store
    }

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                WithPerceptionTracking {
                    ForEach(store.filters, id: \.self) { filter in
                        WithPerceptionTracking {
                            Label(
                                filter.description,
                                systemImage: filter.associatedImage
                            )
                            .font(.caption)
                            .padding(8)
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 8
                                )
                                .foregroundColor(
                                    filter == store.selectedFilter ? .primary : Color.black.opacity(0.6)
                                )
                            )
                            .onTapGesture {
                                store.send(
                                    .onTap(filter),
                                    animation: .easeInOut
                                )
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    FilterView(
        store: Store(
            initialState: Filters.State.init(
                filters: [.onAir, .musical, .timeShift],
                selectedFilter: .musical
            ),
            reducer: {
                Filters()
            }
        )
    )
}

extension StationFilter {
    var associatedImage: String {
        switch self {
        case .timeShift:
            "clock.arrow.circlepath"
        case .onAir:
            "livephoto"
        case .musical:
            "music.note"
        case .locale:
            "flag"
        }
    }
}
