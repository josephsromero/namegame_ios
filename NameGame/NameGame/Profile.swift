//
//  Profile.swift
//  NameGame
//
//  Created by Romero, Joseph on 9/25/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation

class Profile: Codable {
    var id: String?
    var jobTitle: String?
    var firstName: String?
    var lastName: String?
    var headshot: Headshot?
}
