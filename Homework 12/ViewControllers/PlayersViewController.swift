//
//  PlayersViewController.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 01.09.2021.
//

import UIKit

class PlayersViewController: UIViewController {

    @IBOutlet weak var firstPlayerTextField: UITextField!
    @IBOutlet weak var secondPlayerTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var enterLabel: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localized()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        goButton.addBorder(with: .black, borderWidth: 3.0)
        goButton.layer.cornerRadius = goButton.frame.size.height / 2.0
    }
    
    func localized() {
        enterLabel.text = "enterNamesLabel".localized
        firstLabel.text = "firstPlayerLabel".localized
        secondLabel.text = "secondPlayerLabel".localized
    }
    

    
    @IBAction func goButtonAction(_ sender: Any) {
        
        guard let firstName = firstPlayerTextField.text , !firstName.isEmpty, let secondName = secondPlayerTextField.text, !secondName.isEmpty else {
            presentOkAlertController(with: nil, message: "enterAlert".localized, useTextField: false, preferredStyle: .alert)
            return
        }
        
        guard firstPlayerTextField.text!.count <= 10, secondPlayerTextField.text!.count <= 10 else {
            presentOkAlertController(with: nil, message: "lengthAlert".localized, useTextField: false, preferredStyle: .alert)
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        vc.game = GameData()
        let color1 = Int.random(in: 0...1)
        let color2 = color1 == 0 ? 1 : 0
        var checkerStyle1: String
        var checkerStyle2: String
        if color1 == 0 {
            checkerStyle1 = "WhiteChecker\(CheckersSettings.shared.checkersStyle)"
            checkerStyle2 = "BlackChecker\(CheckersSettings.shared.checkersStyle)"
        } else {
            checkerStyle1 = "BlackChecker\(CheckersSettings.shared.checkersStyle)"
            checkerStyle2 = "WhiteChecker\(CheckersSettings.shared.checkersStyle)"
        }
        vc.game?.player1 = Player(name: firstName, checkerColor: color1)
        vc.game?.player2 = Player(name: secondName, checkerColor: color2)
        vc.game?.player1?.checkerStyle = checkerStyle1
        vc.game?.player2?.checkerStyle = checkerStyle2
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PlayersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstPlayerTextField.resignFirstResponder()

        return true
    }
}
