import Testing
import Foundation
@testable
import AwesomePlayer

@preconcurrency
import Combine

@Suite(
    "Audi Player Suite",
    .timeLimit(.minutes(1))
)
struct AudioPlayerTests {

    @Test(
        "Test play function"
    )
    func testPlay() async {

        // GIVEN

        let playBackSpy = AudioPlaybackMock()
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
            insertedItems: [
                AudioItem(
                    id: .init(),
                    url: URL(filePath: "uri://0")!
                ),
                AudioItem(
                    id: .init(),
                    url: URL(filePath:"uri://1")!
                )
            ]
        )

        let sut = AwesomeMediaPlayer(
            audioPlayer: playBackSpy
        )

        let itemToPlay: AudioItem = .init(
            id: UUID(),
            url: URL(filePath:"uri://3")!
        )

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
            insertedItems: [
                AudioItem(
                    id: .init(),
                    url: URL(filePath: "uri://0")!
                ),
                AudioItem(
                    id: .init(),
                    url: URL(filePath:"uri://1")!
                )
            ]
        )

        let sut = AwesomeMediaPlayer(
            audioPlayer: playBackSpy
        )

        let itemToQueue: AudioItem = .init(
            id: UUID(),
            url: URL(filePath:"uri://3")!
        )

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

    @Test("Test Player Has a Queue WHEN PlayNext called THEN Play Next Item in the Queue")
    func testPlayNext() async {

        // GIVEN

        let playBackSpy = AudioPlaybackMock(
            insertedItems: [
                AudioItem(
                    id: .init(),
                    url: URL(filePath: "uri://0")!
                ),
                AudioItem(
                    id: .init(),
                    url: URL(filePath:"uri://1")!
                )
            ]
        )

        let sut = AwesomeMediaPlayer(
            audioPlayer: playBackSpy
        )

        // WHEN

        await sut.playNext()

        // THEN

        #expect(
            playBackSpy.itemsCountValue == 1
        )

        #expect(
            await sut
                .audioStatusPublisher
                .contains {
                    $0 == .playing
                }
        )
    }

    @Test("Test Player Has an Empty Queue WHEN PlayNext called THEN Stop and reset all")
    func testPlayNextWithEmptyQueue() async {

        // GIVEN

        let playBackSpy = AudioPlaybackMock(
            insertedItems: [ ]
        )

        let sut = AwesomeMediaPlayer(
            audioPlayer: playBackSpy
        )

        // WHEN

        await sut.playNext()

        // THEN

        #expect(
            playBackSpy.insertedItems.count == 0
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
