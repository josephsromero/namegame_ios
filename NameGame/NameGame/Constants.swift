//
//  Constants.swift
//  NameGame
//
//  Created by Romero, Joseph on 9/25/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

public class Constants {
    // MARK: - Endpoints
    static let profilesEndpoint: String = "https://willowtreeapps.com/api/v1.0/profiles/"
    
    // MARK: - Color definitions
    static let willowTreeColor: UIColor = UIColor(red: 27.0/255.0, green: 217.0/255.0, blue: 196/255.0, alpha: 1.0)
    static let willowTreeColorDark: UIColor = UIColor(red: 56.0/255.0, green: 138.0/255.0, blue: 150.0/255.0, alpha: 1.0)
    
    // MARK: - Button shadows
    static let shadowColor: CGColor = UIColor.black.cgColor
    static let shadowOffset: CGSize = CGSize(width: 0, height: 4.0)
    static let buttonShadowOffset: CGSize = CGSize(width: 0, height: 2.0)
    static let shadowOpacity: Float = 0.65
    static let buttonShadowOpacity: Float = 0.5
}
