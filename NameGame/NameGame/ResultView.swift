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
    
    var winner: Bool = false
    
    weak var delegate: ResultViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.resetButton.layer.cornerRadius = self.resetButton.frame.height / 2
        self.resultMsgView.layer.cornerRadius = 12
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        self.delegate?.playAgain()
    }
}
