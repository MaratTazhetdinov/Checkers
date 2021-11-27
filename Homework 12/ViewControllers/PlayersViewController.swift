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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        goButton.addBorder(with: .black, borderWidth: 3.0)
        goButton.layer.cornerRadius = goButton.frame.size.height / 2.0
    }
    
    @IBAction func goButtonAction(_ sender: Any) {
        
        guard let firstName = firstPlayerTextField.text , !firstName.isEmpty, let secondName = secondPlayerTextField.text, !secondName.isEmpty else {
            presentOkAlertController(with: nil, message: "You have to enter your names", useTextField: false, preferredStyle: .alert)
            return
        }
        
        guard firstPlayerTextField.text!.count <= 10, secondPlayerTextField.text!.count <= 10 else {
            presentOkAlertController(with: nil, message: "The name couldn't be more than 10 letters", useTextField: false, preferredStyle: .alert)
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
