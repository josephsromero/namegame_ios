//
//  ViewController.swift
//  NameGame
//
//  Created by Matt Kauper on 3/8/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialActivityIndicator

class NameGameViewController: UIViewController {

    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var imageButtons: [FaceButton]!
    
    var game: NameGame = NameGame()
    var indicator: MDCActivityIndicator = MDCActivityIndicator()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.delegate = self
        let orientation: UIDeviceOrientation = self.view.frame.size.height > self.view.frame.size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
        
        //indicator.sizeToFit()
        indicator.center = self.view.center
        view.addSubview(indicator)
        weak var blockSelf: NameGameViewController? = self
        game.loadGameData {
            // TODO show button to start game/ hidden before load?
            blockSelf?.initializeGameView()
        }
    }
    
    // MARK: - Game View methods
    private func initializeGameView() {
        DispatchQueue.main.async {
            self.indicator.startAnimating()
        }
        game.chooseProfiles()
        game.loadProfileImages()
    }
    
    // Helper method for Game Question
    func poseQuestion() {
        if let winner: Coworkers = game.sixProfiles[game.winningProfileId!] {
            let question: String = NSLocalizedString("Who is ", comment: "Question being posed to player")
            let firstName: String = winner.firstName ?? ""
            let lastName: String = winner.lastName ?? ""
            
            var space: String = ""
            if !firstName.isEmpty {
                space = " "
            }
            self.questionLabel.text = question + firstName + space + lastName + "?"
        }
    }
    
    // MARK: - Player interaction methods
    func resetGame() {
        self.initializeGameView()
    }

    @IBAction func faceTapped(_ button: FaceButton) {
        // shows result view with respective win or lose statement
        let nib: UINib = UINib(nibName: "ResultViewController", bundle: nil);
        if let resultVC: ResultView = nib.instantiate(withOwner: nil, options: nil)[0] as? ResultView {
            resultVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            resultVC.delegate = self
            resultVC.winner = game.winningProfileId == button.profileId
            resultVC.modalPresentationStyle = .overCurrentContext
            self.present(resultVC, animated: true, completion: nil)
        }
    }
    // MARK: -

    func configureSubviews(_ orientation: UIDeviceOrientation) {
        if orientation.isLandscape {
            outerStackView.axis = .vertical
            innerStackView1.axis = .horizontal
            innerStackView2.axis = .horizontal
        } else {
            outerStackView.axis = .horizontal
            innerStackView1.axis = .vertical
            innerStackView2.axis = .vertical
        }
        view.setNeedsLayout()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orientation: UIDeviceOrientation = size.height > size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
    }
}

// MARK: - Delegate Implementations
extension NameGameViewController: NameGameDelegate {
    func complete() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
        }
        var buttonIndex: Int = 0
        for (id, _) in game.sixProfiles {
            self.imageButtons[buttonIndex].setImage(ProfileImageService.instance().getImage(profileId: id), for: .normal)
            self.imageButtons[buttonIndex].profileId = id
            buttonIndex += 1
        }
        poseQuestion()
    }
}

extension NameGameViewController: ResultViewDelegate {
    func playAgain() {
        self.presentedViewController?.dismiss(animated: true, completion: {
            self.resetGame()
        })
    }
}
