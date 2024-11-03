import Testing
import Foundation
@testable
import AwesomePlayer

@preconcurrency
import Combine

@Suite(
    "AwesomeMediaPlayer Suite",
    .timeLimit(.minutes(1))
)
struct AwesomeMediaPlayerTests {

    @Test(
        "Test play function"
    )
    func testPlay() async {

        // GIVEN

        let playBackSpy = AudioPlaybackMock(
            playerState: true
        )
        let sut = AwesomeMediaPlayer(
            audioPlayer: playBackSpy
        )

        // WHEN

        await sut.play()

        // THEN

        #expect(
            playBackSpy.playCalled
        )

        #expect(
            await sut
                .audioStatusPublisher
                .contains {
                    $0 == .playing
                }
        )
    }

    @Test("Test Pause function")
    func testPause() async {

        // GIVEN

        let playBackSpy = AudioPlaybackMock()
        let sut = AwesomeMediaPlayer(
            audioPlayer: playBackSpy
        )

        // WHEN

        await sut.pause()

        // THEN

        #expect(
            playBackSpy.pauseCalled
        )

        #expect(
            await sut
                .audioStatusPublisher
                .contains {
                    $0 == .paused
                }
        )
    }

    @Test("Test Player Has Already a playing Item WHEN Play with Item is called THEN Reset all and Play Item")
    func testInterruptionPlay() async {

        // GIVEN

        let playBackSpy = AudioPlaybackMock(
            insertedItems: AudioItemStub.generate(
                n: 2
            ),
            playerState: true
        )

        let sut = AwesomeMediaPlayer(
            audioPlayer: playBackSpy
        )

        let itemToPlay: AudioItem = AudioItemStub.generate()

        // WHEN

        await sut.play(
            item: itemToPlay
        )

        // THEN

        #expect(
            playBackSpy.insertedItems.count == 1
        )

        #expect(
            await sut
                .audioStatusPublisher
                .contains {
                    $0 == .playing
                }
        )
    }

    @Test("Test Player Has Already a playing Items WHEN AddToQueue called THEN Add Item to the Queue")
    func testPlayerQueuing() async {

        // GIVEN

        let playBackSpy = AudioPlaybackMock(
            insertedItems: AudioItemStub.generate(n: 2)
        )

        let sut = AwesomeMediaPlayer(
            audioPlayer: playBackSpy
        )

        let itemToQueue: AudioItem = AudioItemStub.generate()

        // WHEN

        await sut.addToQueue(
            item: itemToQueue
        )

        // THEN

        #expect(
            playBackSpy.insertedItems.count == 3
        )

        #expect(
            await sut
                .audioStatusPublisher
                .contains {
                    $0 == .idle
                }
        )
    }

    @Test("Test Player With Empty Queue WHEN PlayNext called THEN Ignore Action")
    func testPlayNextWithEmptyQueue() async {

        // GIVEN

        let playBackSpy = AudioPlaybackMock(
            insertedItems: AudioItemStub.generate(n: 2),
            playerState: true
        )

        let sut = AwesomeMediaPlayer(
            audioPlayer: playBackSpy
        )

        // WHEN

        await sut.playNext()

        // THEN

        #expect(
            playBackSpy.itemsCountValue == 0
        )
        #expect(
            playBackSpy.playCalled == false
        )

        #expect(
            await sut
                .audioStatusPublisher
                .contains {
                    $0 == .idle
                }
        )
    }
}
