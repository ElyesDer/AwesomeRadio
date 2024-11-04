//
//  StationDetailsView.swift
//  MyLittleRadio
//
//  Created by Elyes Derouiche on 31/10/2024.
//

import SwiftUI
import ComposableArchitecture
import AwesomePlayer

struct StationDetailsView: View {

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
            StickyHeaderContainer(
                minHeight: 300,
                offset: -110
            ) {
                WithPerceptionTracking {
                    HStack {
                        Spacer()
                        Spacer()

                        VerticalCardView(
                            title: store.station.title,
                            subtitle: store.station.shortTitle
                        ) {
                            themeColor
                        }

                        Spacer()

                        Image(
                            systemName: "play.circle.fill"
                        )
                        .resizable()
                        .foregroundStyle(themeColor)
                        .frame(
                            width: 45,
                            height: 45,
                            alignment: .center
                        )
                        .padding()
                        .onTapGesture {
                            store.send(.play)
                        }
                    }

                    Spacer()

                    VStack(alignment: .leading) {
                        Text("Description")
                            .font(.headline)

                        Text("Radio Description Detail")
                            .font(.body)

                        Spacer()
                    }
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .leading
                    )
                    .padding()
                }
            } background: {
                AsyncImage(
                    url: URL(
                        string: store.station.squareImageURL ?? ""
                    )
                ) { image in
                    image
                        .resizable()
                } placeholder: {
                    themeColor
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    StationDetailsView(
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
