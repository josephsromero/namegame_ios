//
//  ResultViewController.swift
//  NameGame
//
//  Created by Romero, Joseph on 9/27/18.
//  Copyright © 2018 WillowTree Apps. All rights reserved.
//

import Foundation
import UIKit

protocol ResultViewControllerDelegate: class {
    func playAgain() -> Void
}

class ResultViewController: UIViewController {
    @IBOutlet weak var resultMsgView: UIView!
    @IBOutlet weak var resultMsgLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    // ResultVC Constants
    let popUpCornerRadius: CGFloat = 12
    let lossResultText: String = NSLocalizedString("That is incorrect.", comment: "User chose the wrong picture")
    let winResultText: String = NSLocalizedString("That is correct!", comment: "User chose the correct picture")
    
    var winner: Bool = false {
        didSet {
            if winner { winningStatement() }
        }
    }
    
    weak var delegate: ResultViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBlur()
        self.resultMsgLabel.text = lossResultText
        self.resetButton.layer.cornerRadius = self.resetButton.frame.height / 2
        self.resetButton = resetButton.addShadowToButton()
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
