//
//  AwesomePlayerView.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 01/11/2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture

public struct AwesomePlayerView: View {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    // MARK: Private Properties

    @Perception.Bindable
    private var store: StoreOf<AwesomePlayer>

    @Namespace
    private var animation

    @State
    private var computedFrameHeight: CGFloat = .zero

    private var isPortrait: Bool {
        horizontalSizeClass == .compact && verticalSizeClass == .regular
    }

    // MARK: Computed Props

    private var themeColor: Color {
        Color(
            hex: store.currentItem?.primaryHexColor ?? "#FFF"
        )
    }

    private var expandedBackgroundColor: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [
                    .primary,
                    .gray,
                    themeColor
                ]
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var retractedBackgroundColor: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [
                    .secondary,
                    themeColor,
                ]
            ),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    public init(store: StoreOf<AwesomePlayer>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack {
                if store.isExpanded {
                    ExpandedPlayer()
                } else {
                    RetractedPlayer()
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }

    // MARK: Retracted Player

    @ViewBuilder
    private func RetractedPlayer() -> some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                Spacer()
                HStack(spacing: 2) {
                    AsyncImage(
                        url: store.currentItem?.coverURL,
                        content: { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        },
                        placeholder: {
                            Image(
                                systemName: "music.note.list"
                            )
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .padding(6)
                            .background(themeColor)
                        })
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 8,
                            style: .continuous
                        )
                    )
                    .frame(
                        width: 40,
                        height: 40,
                        alignment: .center
                    )
                    .padding(.horizontal, 8)
                    .matchedGeometryEffect(
                        id: "AlbumCover",
                        in: animation
                    )

                    VStack(
                        alignment: .leading,
                        spacing: 4
                    ) {
                        AutoScrollText(
                            text: store.currentItem?.mainLabel ?? " - ",
                            font: .systemFont(ofSize: 14),
                            startDelay: 2,
                            duration: 5
                        )
                        .foregroundStyle(.primary)
                        .clipped()

                        AutoScrollText(
                            text: store.currentItem?.secondaryLabel ?? " - ",
                            font: .systemFont(ofSize: 14),
                            startDelay: 3,
                            duration: 5
                        )
                        .foregroundColor(.secondary)
                        .clipped()
                    }

                    Button {
                        store.send(
                            .togglePlayer()
                        )
                    } label: {
                        PlayToggleView()
                            .foregroundStyle(.white)
                            .font(
                                .system(
                                    size: 20
                                )
                            )
                            .padding(.trailing, 18)
                    }
                }

                Spacer()

                VolumeSlider(
                    progress: $store.currentProgress,
                    tint: themeColor
                )
                .frame(height: 4, alignment: .bottom)
                .disabled(store.currentItem?.isTimeShiftable ?? false)
                .matchedGeometryEffect(
                    id: "PlayerProgress",
                    in: animation
                )
            }
            .frame(
                height: max(
                    60,
                    computedFrameHeight
                )
            )
            .background(
                retractedBackgroundColor
            )
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onChanged({ value in
                        let transactionY = 60 - value.translation.height
                        computedFrameHeight = transactionY > 0 ? transactionY : 0
                        withAnimation(.spring()) {
                            if value.translation.height < -50 {
                                store.send(.togglePlayerView(true))
                                computedFrameHeight = .zero
                            }
                        }
                    })
                    .onEnded({ value in
                        withAnimation(.spring()) {
                            if value.translation.height < 0 {
                                store.send(.togglePlayerView(true))
                                computedFrameHeight = .zero
                            }
                        }
                    })
            )
            .transition(.move(edge: .top))
            .onTapGesture {
                store.send(
                    .togglePlayerView(),
                    animation: .linear
                )
            }
        }
    }

    // MARK: Expanded Player

    @ViewBuilder
    private func Cover() -> some View {
        AsyncImage(
            url: store.currentItem?.coverURL,
            content: { image in
                image
                    .resizable()
                    .aspectRatio(
                        contentMode: .fit
                    )
            },
            placeholder: {
                ProgressView()
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                    .background(themeColor)
            }
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 15,
                style: .continuous
            )
        )
        .scaleEffect(
            store.playerStatus == AudioPlayerState.playing ? 1 : 0.9
        )
        .animation(
            .bouncy,
            value: store.playerStatus
        )
        .popEffect(
            blurEffect: 100
        )
        .matchedGeometryEffect(
            id: "AlbumCover",
            in: animation
        )
    }

    private func computeCoverHeightRatio() -> CGFloat {
        isPortrait ? 0.48 : 0.75
    }

    private func computePlayerHeightRatio() -> CGFloat {
        isPortrait ? 0.42 : 0.7
    }

    @ViewBuilder
    private func ExpandedPlayer() -> some View {
        GeometryReader { reader in
            WithPerceptionTracking {
                VStack(spacing: 4) {
                    Capsule()
                        .fill(.gray)
                        .frame(width: 40, height: 5)
                        .padding(.top, 2)

                    HStack(alignment: .top) {
                        Text("Now Playing")
                            .font(.title)
                            .bold()
                            .foregroundStyle(themeColor)

                        Spacer()

                        Button(action: {
                            store.send(
                                .togglePlayerView(),
                                animation: .spring()
                            )
                        }) {
                            Image(systemName: "chevron.down")
                                .foregroundStyle(themeColor)
                                .padding()
                        }
                    }

                    let layout = isPortrait ? AnyLayout(
                        VStackLayout(
                            spacing: 2
                        )
                    ) : AnyLayout(
                        HStackLayout(
                            spacing: 4
                        )
                    )

                    layout {
                        Group {
                            if store.isWaitingListShown {
                                Group {
                                    if store.playingList.isEmpty {
                                        EmptyWaitingList()
                                    } else {
                                        WaitingList()
                                    }
                                }
                                .padding(4)
                                .background(themeColor)
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: 15,
                                        style: .continuous
                                    )
                                )
                            } else {
                                Cover()
                            }
                        }
                        .frame(
                            height: reader.size.height * computeCoverHeightRatio()
                        )

                        Spacer(minLength: 24)

                        PlayerView(
                            reader.size
                        )
                        .padding(.bottom, 40)
                        .frame(
                            maxHeight: reader.size.height * computePlayerHeightRatio()
                        )
                    }
                }
                .padding(16)
                .frame(maxHeight: .infinity)
                .background(
                    UnevenRoundedRectangle(
                        cornerRadii: .init(
                            topLeading: 15,
                            bottomLeading: 0,
                            bottomTrailing: 0,
                            topTrailing: 15
                        )
                    )
                    .fill(
                        expandedBackgroundColor
                    )
                    .ignoresSafeArea()
                )
                .offset(
                    y: computedFrameHeight
                )
                .gesture(
                    DragGesture(minimumDistance: 50)
                        .onChanged({ value in
                            let transactionY = value.translation.height
                            computedFrameHeight = transactionY > 0 ? transactionY : 0
                        })
                        .onEnded({ value in
                            withAnimation {
                                if value.location.y > 50 {
                                    store.send(.togglePlayerView(false))
                                    computedFrameHeight = .zero
                                }
                            }
                        })
                )
            }
        }
    }

    @ViewBuilder
    private func WaitingList() -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                WithPerceptionTracking {
                    ForEach(store.playingList, id: \.self) { item in
                        StationRow(
                            audioItem: item
                        )
                        .onTapGesture {
                            store.send(.play(item))
                        }
                        Divider()
                    }
                }
            }
            .padding(6)
        }
    }

    @ViewBuilder
    private func EmptyWaitingList() -> some View {
        VStack {
            Image(
                systemName: "text.insert"
            )
            .font(
                .system(
                    size: 20
                )
            )

            Text("Add Stations to Your Waiting List")
        }
        .padding()
    }

    /// Player View (containing all the song information with playback controls)
    @ViewBuilder
    private func PlayerView(_ mainSize: CGSize) -> some View {
        GeometryReader { reader in
            WithPerceptionTracking {
                let size = reader.size
                let spacing = size.height * 0.04

                VStack(spacing: spacing) {
                    VStack(spacing: spacing) {
                        HStack(alignment: .center, spacing: 15) {
                            VStack(alignment: .leading, spacing: 4) {
                                AutoScrollText(
                                    text: store.currentItem?.mainLabel ?? " - ",
                                    font: .boldSystemFont(ofSize: 20),
                                    alignment: .leading,
                                    startDelay: 2,
                                    duration: 5
                                )
                                .foregroundColor(.primary)

                                AutoScrollText(
                                    text: store.currentItem?.secondaryLabel ?? " - ",
                                    font: .systemFont(ofSize: 18),
                                    alignment: .leading,
                                    startDelay: 2,
                                    duration: 5
                                )
                                .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        VolumeSlider(
                            progress: $store.currentProgress,
                            tint: themeColor
                        )
                        .matchedGeometryEffect(
                            id: "PlayerProgress",
                            in: animation
                        )
                        .frame(height: 5)

                        HStack {
                            Text("0:00")
                                .font(.caption)
                                .foregroundColor(.gray)

                            Spacer(minLength: 0)

                            Text("live")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(
                        height: size.height / 2.5,
                        alignment: .top
                    )

                    HStack(spacing: 10) {
                        Button {
                            store.send(
                                .set(
                                    \.currentProgress,
                                     max(
                                        store.currentProgress - (10 / 100),
                                        0
                                     )
                                )
                            )
                        } label: {
                            Image(systemName: "gobackward.10")
                                .font(
                                    .system(
                                        size: 20
                                    )
                                )
                        }

                        Spacer()

                        Button {
                            store.send(.playNext)
                        } label: {
                            Image(systemName: "backward.fill")
                                .font(
                                    .system(
                                        size: 28
                                    )
                                )
                                .foregroundStyle(Color.gray)
                        }
                        .disabled(true)

                        Button(action: {
                            store.send(.togglePlayer())
                        }) {
                            ZStack {
                                Circle()
                                    .fill(themeColor)
                                    .frame(height: 60)

                                PlayToggleView()
                                    .font(
                                        .system(
                                            size: 36
                                        )
                                    )
                            }
                        }

                        Button {
                            store.send(.playNext)
                        } label: {
                            Image(systemName: "forward.fill")
                                .font(
                                    .system(
                                        size: 28
                                    )
                                )
                        }

                        Spacer()

                        Button {
                            store.send(
                                .set(
                                    \.currentProgress,
                                     min(
                                        store.currentProgress + (10 / 100),
                                        1
                                     )
                                )
                            )
                        } label: {
                            Image(systemName: "goforward.10")
                                .font(
                                    .system(
                                        size: 20
                                    )
                                )
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .frame(maxHeight: .infinity)

                    VStack(spacing: spacing) {
                        HStack(spacing: 15) {
                            Image(systemName: "speaker.fill")
                                .foregroundColor(.gray)

                            VolumeSlider(
                                progress: $store.volume,
                                tint: themeColor
                            )
                            .frame(height: 8)

                            Image(systemName: "speaker.wave.3.fill")
                                .foregroundColor(.gray)
                        }

                        HStack(
                            alignment: .top,
                            spacing: size.width * 0.18
                        ) {
                            Button {

                            } label: {
                                // check https://www.youtube.com/watch?v=KL50qKi66EQ
                                Image(systemName: "heart")
                                    .font(.title2)
                            }
                            .disabled(true)

                            VStack(spacing: 6) {
                                Button {

                                } label: {
                                    Image(systemName: "airpods.gen3")
                                        .font(.title2)
                                }
                            }

                            Button {
                                store.send(
                                    .toggleWaitingList,
                                    animation: .linear
                                )
                            } label: {
                                Image(systemName: "list.bullet")
                                    .font(.title2)
                                    .padding(4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(store.isWaitingListShown ? Color.primary : .clear)
                                    )
                            }
                        }
                        .foregroundColor(.white)
                        .blendMode(.overlay)
                        .padding(
                            .top,
                            spacing
                        )
                    }
                    .frame(
                        height: size.height / 2.5,
                        alignment: .bottom
                    )
                }
            }
        }
    }

    @ViewBuilder
    private func PlayToggleView() -> WithPerceptionTracking<_ConditionalContent<Image, Image>> {
        WithPerceptionTracking {
            switch store.playerStatus {
            case .playing:
                Image(
                    systemName: "pause.fill"
                )
            case .idle, .paused:
                Image(
                    systemName: "play.fill"
                )
            }
        }
    }
}

#Preview {
    ZStack {
        Color.red
            .ignoresSafeArea()
    }
    .safeAreaInset(edge: .bottom) {
        AwesomePlayerView(
            store: Store(
                initialState: AwesomePlayer.State(
                    isExpanded: true,
                    playingList: [ AudioItem(
                        id: .init(),
                        streamUrl: URL(
                            string:
                                "https://icecast.radiofrance.fr/franceinter-midfi.mp3"
                        )!,
                        mainLabel: "France Inter Radio Station",
                        secondaryLabel: "France Inter Radio Station, Programme du matin et soir à écouter sur notre radio",
                        coverURL: URL(
                            string:
                                "https://www.radiofrance.fr/s3/cruiser-production/2022/05/480e3b05-9cd6-4fb3-aa4f-6d60964c70b7/1000x1000_squareimage_francemusique_v2.jpg"
                        )!,
                        primaryHexColor: "#e20134",
                        isTimeShiftable: false
                    )]
                ),
                reducer: {
                    AwesomePlayer()
                }
            )
        )
    }
}
