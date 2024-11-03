//
//  StationCardView.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 03/11/2024.
//

import SwiftUI
import ComposableArchitecture

struct StationCardView: View {

    @Perception.Bindable
    private var store: StoreOf<StationDetails>

    private let themeColor: Color

    init(store: StoreOf<StationDetails>) {
        self.store = store
        self.themeColor = Color(
            hex: store.station.primaryColor
        )
    }

    var body: some View {
        WithPerceptionTracking {
            FullWidthCard(
                title: store.station.shortTitle,
                subtitle: store.station.brandID
            ) {
                WithPerceptionTracking {
                    AsyncImage(
                        url: URL(
                            string: store.station.squareImageURL ?? ""
                        )
                    ) { image in
                        image
                            .resizable()
                    } placeholder: {
                        WithPerceptionTracking {
                            ZStack {
                                themeColor

                                Text(
                                    store.station.title
                                )
                                .font(.system(size: 42))
                                .bold()
                                .foregroundStyle(
                                    .white
                                )
                                .offset(y: -10)
                            }
                        }
                    }
                }
            } actionView: {
                Image(
                    systemName: "play.circle.fill"
                )
                .font(.system(size: 30))
                .padding(.horizontal)
                .onTapGesture {
                    store.send(.play)
                }
            }
            .onTapGesture {
                store.send(.onTap)
            }
        }
    }
}

#Preview {
    StationCardView(
        store: Store(
            initialState: StationDetails.State.init(
                station: StationFeatureMock.stations.first!
            ),
            reducer: {
                StationDetails()
            }
        )
    )
}
