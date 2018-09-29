//
//  NameGame.swift
//  NameGame
//
//  Created by Erik LaManna on 11/7/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

public enum GameTypes {
    case standard
    case matt
    case team
}

protocol NameGameDelegate: class {
    func complete() -> Void
}

class NameGame {
    weak var delegate: NameGameDelegate?
    
    private var gameMode: GameTypes = GameTypes.standard
    private var networkService: NetworkService
    // Collections for profile data
    var profiles: [Profile] = [Profile]()
    var sixProfiles: [String: Profile] = [String: Profile]()

    var winningProfileId: String?
    let numberPeople = 6
    
    init(gameMode: GameTypes, networkService: NetworkService) {
        self.gameMode = gameMode
        self.networkService = networkService
    }
    
    // Load JSON data from API
    func loadGameData(completion: @escaping () -> Void) {
        self.networkService.getProfiles {
            completion()
        }
    }
    
    func chooseProfiles() {
        sixProfiles.removeAll()
        var count: Int = 0
        
        while count < numberPeople {
            let randIndex: Int = Int.random(in: 0..<ProfileService.instance().count())
            let profile: Profile = ProfileService.instance().get(index: randIndex)
            if profile.headshot!.url != nil {
                sixProfiles[profile.id!] = profile
                count += 1
            }
            
            // Select a profile for winState
            if count == numberPeople {
                self.winningProfileId = profile.id
            }
        }
    }
    
    func loadProfileImages() {
        let dispatch: DispatchGroup = DispatchGroup()
        for (id, profile) in self.sixProfiles {
            let url: URL = profile.headshot!.url!
            // Use dispatch to sync img loading tasks
            dispatch.enter()
            ProfileImageService.instance().fetchImage(profileId: id, url: url) {
                dispatch.leave()
            }
        }
        
        dispatch.notify(queue: .main) {
            self.delegate?.complete()
        }
    }
    
    func questionBuilder() -> String {
        guard let winner: Profile = self.sixProfiles[self.winningProfileId ?? ""] else {
            return NSLocalizedString("The Name Game", comment: "Title of the game")
        }

        let question: String = NSLocalizedString("Who is ", comment: "Question being posed to player")
        let firstName: String = winner.firstName ?? ""
        let lastName: String = winner.lastName ?? ""
        let space: String = !firstName.isEmpty ? " " : ""

        return question + firstName + space + lastName + "?"
    }
}
