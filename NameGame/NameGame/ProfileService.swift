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
        return profiles[index]
    }
    
    func clear() {
        self.profiles.removeAll()
    }
    
    func count() -> Int {
        return profiles.count
    }
    
    func filterOn(gameType: GameTypes) -> [Profile] {
        switch gameType {
        case .matt:
            return profiles.filter({ $0.firstName != nil && ($0.firstName!.lowercased() == "matt" || $0.firstName!.lowercased() == "matthew")})
        case .team:
            return profiles.filter({ $0.jobTitle != nil })
        default:
            return profiles
        }
    }
}
