//
//  File.swift
//  AwesomePlayer
//
//  Created by Elyes Derouiche on 02/11/2024.
//

import Foundation
import Testing
import Foundation
@testable
import AwesomePlayer
import Combine
import ComposableArchitecture

@Suite(
    "AwesomePlayer Reducer Tests Suite",
    .timeLimit(.minutes(1))
)
@MainActor
final class AwesomePlayerTests {

    var mediaPlayer: MediaPlayerMock!

    init(
        mediaPlayer: MediaPlayerMock = MediaPlayerMock()
    ) {
        self.mediaPlayer = mediaPlayer
    }

    deinit {
        mediaPlayer = nil
    }

    func makeStore(
        state: AwesomePlayer.State = .init(),
        mediaPlayer: MediaPlayer = MediaPlayerMock()
    ) -> TestStoreOf<AwesomePlayer> {
        TestStore(
            initialState: state) {
                AwesomePlayer()
            } withDependencies: {
                $0.mediaPlayer = mediaPlayer
            }
    }

    // MARK: View LifeCycle

    @Test("On Store Appear THEN Setup And Subscribe To Player Publishers")
    func onAppear() async {

        // GIVEN
        let audioItem: AudioItem = AudioItemStub.generate()

        let store = makeStore(
            state: .init(playingList: [
                audioItem
            ]),
            mediaPlayer: mediaPlayer
        )

        // WHEN

        await store.send(.onAppear)

        // THEN

        await store.receive(\.playerCurrentItemUpdate)
        await store.receive(\.playerProgressUpdate )
        await store.receive(\.playerStatusUpdate, .idle)

        #expect(await mediaPlayer.addToQueueCalled)
        #expect( mediaPlayer.audioStatusPublisherCalled)
        #expect(mediaPlayer.currentItemPublisherCalled)
        #expect(mediaPlayer.currentProgressPublisherCalled)
    }

    // MARK: Player Action

    @Test("On Toggle Play Action with True Then Call MediaPlayer.PLay")
    func onTogglePlayWithTrue() async {

        // GIVEN

        let store = makeStore(
            mediaPlayer: mediaPlayer
        )

        // WHEN

        await store.send(.togglePlayer(true))

        // THEN

        #expect(await mediaPlayer.playCalled)
    }

    @Test("On Toggle Play Action with False Then Call MediaPlayer.Pause")
    func onTogglePlayWithFalse() async {

        // GIVEN

        let store = makeStore(
            mediaPlayer: mediaPlayer
        )

        // WHEN

        await store.send(.togglePlayer(false))

        // THEN

        #expect(await mediaPlayer.pauseCalled)
    }

    @Test("On Add To Queue AudioItem Then Call MediaPlayer.AddToQueue")
    func onAddToQueueAction() async {

        // GIVEN

        let audioItem: AudioItem = AudioItemStub.generate()

        let store = makeStore(
            mediaPlayer: mediaPlayer
        )

        // WHEN

        await store.send(
            .addToQueue(
                audioItem
            )
        )

        // THEN

        #expect(await mediaPlayer.addToQueueCalled)
        #expect(
            await mediaPlayer.addToQueueArg?.id == audioItem.id
        )
    }

    @Test("On Player Progress Update Then Compute Progress and update State")
    func onStreamProgressUpdate() async {

        // GIVEN

        let playingItem = PlayingItem(
            duration: 10,
            current: 5
        )

        let store = makeStore(
            mediaPlayer: mediaPlayer
        )

        // WHEN

        await store.send(
            .playerProgressUpdate(playingItem)
        ) {
            // THEN
            $0.progress = playingItem
            $0.currentProgress = 0.5
        }
    }

    @Test("On Live Player Progress Update Then Compute Progress and update State")
    func onLiveProgressUpdate() async {

        // GIVEN

        let playingItem = PlayingItem(
            duration: nil,
            current: 5
        )

        let store = makeStore(
            mediaPlayer: mediaPlayer
        )

        // WHEN

        await store.send(
            .playerProgressUpdate(playingItem)
        ) {
            // THEN
            $0.progress = playingItem
            $0.currentProgress = 1
        }
    }

    @Test("On Progress Bar Dragged Then Update Player Progress")
    func onUserInitiatedUpdateProgress() async {

        // GIVEN
        let playingItem = PlayingItem(
            duration: 10,
            current: 5
        )

        let store = makeStore(
            state: .init(
                progress: playingItem
            ),
            mediaPlayer: mediaPlayer
        )

        // WHEN

        await store.send(
            .binding(.set(\.currentProgress, 0.5))
        ) {
            $0.currentProgress = 0.5
        }

        // THEN

        #expect(
            await mediaPlayer.seekToCalled
        )

        #expect(
            await mediaPlayer.seekToArg as! CGFloat == 5
        )
    }


    // MARK: ViewState

    @Test("On Toggle Retracted Player Then Popup Full Screen Player")
    func onToggleFullScreenPlayerView() async {

        // GIVEN

        let store = makeStore(
            state: .init(
                isExpanded: false
            ),
            mediaPlayer: mediaPlayer
        )

        // WHEN

        await store.send(
            .togglePlayerView(true)
        ) {
            // THEN
            $0.isExpanded = true
        }
    }

    @Test("On Toggle Expanded Player Then Retract Player")
    func onToggleRetractedPlayerView() async {

        // GIVEN

        let store = makeStore(
            state: .init(
                isExpanded: true
            ),
            mediaPlayer: mediaPlayer
        )

        // WHEN

        await store.send(
            .togglePlayerView(false)
        ) {
            // THEN
            $0.isExpanded = false
        }
    }

}
