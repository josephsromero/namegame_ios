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
    var mattButton: UIButton!
    var teamButton: UIButton!
    
    var loadingIndicator: JGProgressHUD!

    var game: NameGame!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let networkService: NetworkService = NetworkService()
        game = NameGame(networkService: networkService)
        game.delegate = self

        let orientation: UIDeviceOrientation = self.view.frame.size.height > self.view.frame.size.width ? .portrait : .landscapeLeft
        configureSubviews(orientation)
        outerStackView.isHidden = true
        
        poseQuestion()
        createLoadingIndicator()
        createButtons()

        game.loadGameData {
            self.toggleButtons()
        }
    }
    
    // MARK: - Game View methods
    private func createButtons() {
        self.startButton = createModeButton(yPos: 0, buttonTitle: NSLocalizedString("Start Game", comment: "Start playing standard"))
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        self.mattButton = createModeButton(yPos: self.startButton.frame.height * 1.5, buttonTitle: "Play Matt Mode")
        mattButton.addTarget(self, action: #selector(mattButtonTapped), for: .touchUpInside)
        self.teamButton = createModeButton(yPos: self.startButton.frame.height * 3, buttonTitle: "Play Team Mode")
        teamButton.addTarget(self, action: #selector(teamButtonTapped), for: .touchUpInside)

    }

    private func createModeButton(yPos: CGFloat, buttonTitle: String) -> UIButton {
        var button: UIButton = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 180, height: 44)
        button.center = self.view.center
        button.center.y += yPos
        button.backgroundColor = Constants.willowTreeColorDark
        button.layer.cornerRadius = button.frame.height / 2
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.isHidden = true
        button.isEnabled = false
        button = button.addShadowToButton()
        self.view.addSubview(button)
        return button
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
    
    private func toggleButtons() {
        weak var blockSelf: NameGameViewController? = self
        DispatchQueue.main.async {
            blockSelf?.startButton.isHidden = false
            blockSelf?.startButton.isEnabled = true
            blockSelf?.mattButton.isHidden = false
            blockSelf?.mattButton.isEnabled = true
            blockSelf?.teamButton.isHidden = false
            blockSelf?.teamButton.isEnabled = true
        }
    }
    
    private func gameModeButtonTapped() {
        startButton.removeFromSuperview()
        mattButton.removeFromSuperview()
        teamButton.removeFromSuperview()
        outerStackView.isHidden = false
    }
    
    @objc func startButtonTapped() {
        gameModeButtonTapped()
        game.setGameMode(gameMode: .standard)
        initializeGameView()
    }
    
    @objc func mattButtonTapped() {
        gameModeButtonTapped()
        game.setGameMode(gameMode: .matt)
        initializeGameView()
    }
    
    @objc func teamButtonTapped() {
        gameModeButtonTapped()
        game.setGameMode(gameMode: .team)
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
