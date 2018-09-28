//
//  NameGame.swift
//  NameGame
//
//  Created by Erik LaManna on 11/7/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

protocol NameGameDelegate: class {
    func complete() -> Void
}

class NameGame {
    weak var delegate: NameGameDelegate?
    
    // Collections for profile data
    var profiles: [Coworkers] = [Coworkers]()
    var sixProfiles: [String: Coworkers] = [String: Coworkers]()

    var winningProfileId: String?
    let numberPeople = 6
    
    // Load JSON data from API
    func loadGameData(completion: @escaping () -> Void) {
        if let url: URL = URL(string: Constants.profilesEndpoint) {
            
            weak var blockSelf: NameGame? = self
            let task = URLSession.shared.dataTask(with: url) { (data: Data?, resp: URLResponse?, error: Error?) in
                if error != nil {
                    print(error!)
                } else {
                    if data != nil {
                        do {
                            if let jsonArray: [Any] = try JSONSerialization.jsonObject(with: data!, options: []) as? [Any] {
                                let decoder = JSONDecoder()
                                for item in jsonArray {
                                    let data = try JSONSerialization.data(withJSONObject: item, options: [])
                                    let coworker: Coworkers = try decoder.decode(Coworkers.self, from: data)
                                    blockSelf?.profiles.append(coworker)
                                }
                                completion()
                            }
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func chooseProfiles() {
        sixProfiles.removeAll()
        var count: Int = 0
        
        while count < numberPeople {
            let randIndex: Int = Int.random(in: 0..<self.profiles.count)
            let profile: Coworkers = self.profiles[randIndex]
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
        guard let winner: Coworkers = self.sixProfiles[self.winningProfileId!] else { return "?" }

        let question: String = NSLocalizedString("Who is ", comment: "Question being posed to player")
        let firstName: String = winner.firstName ?? ""
        let lastName: String = winner.lastName ?? ""
        
        var space: String = ""
        if !firstName.isEmpty {
            space = " "
        }
        return question + firstName + space + lastName + "?"
    }
}
