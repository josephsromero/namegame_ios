//
//  ResultView.swift
//  NameGame
//
//  Created by Romero, Joseph on 9/27/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

protocol ResultViewDelegate: class {
    func playAgain() -> Void
}

class ResultView: UIViewController {
    @IBOutlet weak var resultMsgView: UIView!
    @IBOutlet weak var resultMsgLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    // ResultVC Constants
    let popUpCornerRadius: CGFloat = 12
    let lossResultText: String = NSLocalizedString("Oops. That is incorrect.", comment: "User chose the wrong picture")
    let winResultText: String = NSLocalizedString("Yes, that is correct!", comment: "User chose the correct picture")
    
    var winner: Bool = false {
        didSet {
            if winner { winningStatement() }
        }
    }
    
    weak var delegate: ResultViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBlur()
        self.resultMsgLabel.text = lossResultText
        self.resetButton.layer.cornerRadius = self.resetButton.frame.height / 2
        self.resetButton.layer.shadowColor = Constants.shadowColor
        self.resetButton.layer.shadowOffset = Constants.buttonShadowOffset
        self.resetButton.layer.shadowOpacity = Constants.buttonShadowOpacity
        self.resultMsgView.layer.cornerRadius = popUpCornerRadius
    }
    
    func createBlur() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurView)
        self.view.sendSubview(toBack: blurView)
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        self.delegate?.playAgain()
    }
    
    func winningStatement() {
        self.resultMsgLabel.text = winResultText
    }
}
