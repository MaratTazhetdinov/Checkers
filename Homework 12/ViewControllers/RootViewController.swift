//
//  ViewController.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 25.07.2021.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet var buttons: [CustomButton]!
    
    let vcIDs: [String] = ["PlayersViewController", "ResultsViewController", "SettingsViewController"]

    override func viewDidLoad() {    
        super.viewDidLoad()

        for index in 0..<buttons.count {
            buttons[index].delegate = self
        }
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localized()
    }
    
    func localized() {
        buttons[0].text = "newGameButton".localized
        buttons[1].text = "resultsButton".localized
        buttons[2].text = "settingsButton".localized
    }
    
    func getViewController (from id: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let currentViewController = storyboard.instantiateViewController(withIdentifier: id)
        return currentViewController
    }

}

extension RootViewController: CustomButtonDelegate {
    
    func customButtonDidTap(_sender sender: CustomButton) {
        
        guard var vc = getViewController(from: vcIDs[sender.tag]) else { return }
        
        if sender.tag == 0,
           let game = GameData.getData(),
           let gameVC = getViewController(from: "GameViewController") as? GameViewController {
            gameVC.game = game
            vc = gameVC
            presentAlertController(with: nil,
                                   message: "savedGameAlertMessage".localized,
                                   preferredStyle: .alert,
                                   actions: UIAlertAction(title: "continueAlert".localized, style: .default,
                                                          handler: { _ in
                                                          self.navigationController?.pushViewController(vc, animated: true)
                                                            }),
                                   UIAlertAction(title: "startAlert".localized, style: .default,
                                                          handler: { _ in
                                                          game.delete()
                                                          self.navigationController?.pushViewController(self.getViewController(from: self.vcIDs[0])!, animated: true)
                                                            })
                                   )
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

