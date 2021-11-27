//
//  ResultsViewController.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 25.07.2021.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.layer.cornerRadius = backButton.frame.size.height / 4.5
        backButton.addBorder(with: .black, borderWidth: 3.0)
    }
}
