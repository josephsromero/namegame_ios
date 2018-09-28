//
//  FaceButton.swift
//  NameGame
//
//  Created by Intern on 3/11/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

open class FaceButton: UIButton {
    var profileId: String = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        setTitleColor(.white, for: .normal)
        titleLabel?.alpha = 0.0
        
        let cornerRadius: CGFloat = self.frame.height / 2
        self.imageView?.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false

        addShadow()
    }
    
    func addShadow() {
        self.layer.shadowColor = Constants.shadowColor
        self.layer.shadowOffset = Constants.shadowOffset
        self.layer.shadowOpacity = Constants.shadowOpacity
    }
}
