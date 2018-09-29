//
//  NameGameTests.swift
//  NameGameTests
//
//  Created by Romero, Joseph on 9/29/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import XCTest

class NameGameTests: XCTestCase {
    var game: NameGame!
    var fetchedImages: Bool = false

    override func setUp() {
        game = NameGame(networkService: NetworkService())
        game.loadGameData {
        }
    }

    override func tearDown() {
        super.tearDown()
    }

    func testLoadGameData() {
        let testProfile: Profile = ProfileService.instance().get(index: 25)
        XCTAssertNotNil(testProfile)
    }

    func testChooseProfile() {
        game.chooseProfiles()
        XCTAssertNotNil(game.winningProfileId)
        XCTAssertEqual(game.gameProfiles.count, 6)
        
        game.setGameMode(gameMode: .matt)
        game.chooseProfiles()
        XCTAssert(game.gameProfiles[game.winningProfileId!]!.firstName!.lowercased() == "matt" || game.gameProfiles[game.winningProfileId!]!.firstName!.lowercased() == "matthew")
        
        game.setGameMode(gameMode: .team)
        game.chooseProfiles()
        XCTAssertNotNil(game.gameProfiles[game.winningProfileId!]!.jobTitle)
    }
    
    func testLoadProfileImage() {
        game.loadProfileImages()
        sleep(5)
        XCTAssertTrue(fetchedImages)
    }
    
    func testQuestionBuilder() {
        game.winningProfileId = nil
        XCTAssertEqual(game.questionBuilder(), "The Name Game")
    }

}

extension NameGameTests: NameGameDelegate {
    func complete() {
        self.fetchedImages = true
    }
}
