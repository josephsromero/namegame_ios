//
//  ViewController.swift
//  NameGame
//
//  Created by Matt Kauper on 3/8/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import UIKit
import Foundation
import JGProgressHUD

class NameGameViewController: UIViewController {

    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var imageButtons: [FaceButton]!
    var startButton: UIButton!
    var loadingIndicator: JGProgressHUD!

    var game: NameGame!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let networkService: NetworkService = NetworkService()
        game = NameGame(gameMode: .standard, networkService: networkService)
        game.delegate = self

        let orientation: UIDeviceOrientation = self.view.frame.size.height > self.view.frame.size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
        self.outerStackView.isHidden = true
        
        poseQuestion()
        createLoadingIndicator()
        createStartButton()

        weak var blockSelf: NameGameViewController? = self
        game.loadGameData {
            DispatchQueue.main.async {
                blockSelf?.startButton.isHidden = false
                blockSelf?.startButton.isEnabled = true
            }
        }
    }
    
    // MARK: - Game View methods
    private func createStartButton() {
        self.startButton = UIButton(type: .custom)
        startButton.frame = CGRect(x: 0, y: 0, width: 180, height: 44)
        startButton.center = self.view.center
        startButton.backgroundColor = Constants.willowTreeColorDark
        startButton.layer.cornerRadius = startButton.frame.height / 2
        startButton.setTitle(NSLocalizedString("Start Game", comment: "Start playing the game"), for: .normal)
        startButton.setTitleColor(UIColor.white, for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.isHidden = true
        startButton.isEnabled = false
        self.view.addSubview(startButton)
    }
    
    private func createLoadingIndicator() {
        self.loadingIndicator = JGProgressHUD(style: .dark)
        loadingIndicator.center = self.view.center
        loadingIndicator.textLabel.text = NSLocalizedString("Loading", comment: "App is loading next set of images")
        loadingIndicator.animation = JGProgressHUDFadeZoomAnimation()
    }
    
    private func initializeGameView() {
        DispatchQueue.main.async {
            self.loadingIndicator.show(in: self.view)
        }
        game.chooseProfiles()
        game.loadProfileImages()
    }
    
    // Helper method for Game Question
    func poseQuestion() {
        self.questionLabel.text = game.questionBuilder()
    }
    
    // MARK: - Player interaction methods
    func resetGame() {
        initializeGameView()
    }

    @IBAction func faceTapped(_ button: FaceButton) {
        // shows result view with respective win or lose statement
        let nib: UINib = UINib(nibName: "ResultViewController", bundle: nil);
        if let resultVC: ResultViewController = nib.instantiate(withOwner: nil, options: nil)[0] as? ResultViewController {
            resultVC.delegate = self
            resultVC.winner = game.winningProfileId == button.profileId
            resultVC.modalPresentationStyle = .overCurrentContext
            self.present(resultVC, animated: true, completion: nil)
        }
    }
    
    @objc func startButtonTapped() {
        self.startButton.removeFromSuperview()
        self.outerStackView.isHidden = false
        initializeGameView()
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
extension NameGameViewController: NameGameDelegate, ResultViewControllerDelegate {
    func complete() {
        weak var blockSelf: NameGameViewController? = self
        DispatchQueue.main.async {
            blockSelf?.loadingIndicator.dismiss()
        }
        // element == (profileId, Coworker) tuple
        for (index, element) in game.gameProfiles.enumerated() {
            if let buttonImg: UIImage = ProfileImageService.instance().getImage(profileId: element.key) {
                if let imgView: UIImageView = blockSelf?.imageButtons[index].imageView {
                    DispatchQueue.main.async {
                        UIView.transition(with: imgView, duration: 0.75, options: .transitionCrossDissolve, animations: {blockSelf?.imageButtons[index].setImage(buttonImg, for: .normal)}, completion: nil)
                    }
                }
            }
            blockSelf?.imageButtons[index].profileId = element.key
        }
        poseQuestion()
    }
    
    func playAgain() {
        self.presentedViewController?.dismiss(animated: true, completion: {
            self.resetGame()
        })
    }
}
