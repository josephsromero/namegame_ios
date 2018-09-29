//
//  UIButton+Effects.swift
//  NameGame
//
//  Created by Romero, Joseph on 9/29/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func addShadowToButton() -> UIButton {
        self.layer.shadowColor = Constants.shadowColor
        self.layer.shadowOffset = Constants.shadowOffset
        self.layer.shadowOpacity = Constants.shadowOpacity
        return self
    }
}
