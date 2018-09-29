//
//  ProfileService.swift
//  NameGame
//
//  Created by Romero, Joseph on 9/29/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation

class ProfileService {
    private static var theInstance: ProfileService?
    
    // collection to store fetched images, can reduce time to fetch future images
    private var profiles: [Profile] = [Profile]()
    
    public static func instance() -> ProfileService {
        if self.theInstance == nil {
            theInstance = ProfileService()
        }
        return theInstance!
    }
    
    func add(profile: Profile) {
        self.profiles.append(profile)
    }
    
    func get(index: Int) -> Profile {
        return self.profiles[index]
    }
    
    func clear() {
        profiles.removeAll()
    }
    
    func count() -> Int {
        return self.profiles.count
    }
    
    func filterOn(gameType: GameTypes) -> [Profile] {
        switch gameType {
        case .matt:
            return profiles
        case .team:
            return profiles
        default:
            return profiles
        }
    }
}
