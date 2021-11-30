//
//  InfoViewController.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 01.08.2021.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localized()
    }
    
    func localized() {
        backButton.setTitle("backButton".localized, for: .normal)
        headerLabel.text = "infoHeaderLabel".localized
        label1.text = "infoLabel1".localized
        label2.text = "infoLabel2".localized
        label3.text = "infoLabel3".localized
        label4.text = "infoLabel4".localized
        label5.text = "infoLabel5".localized
        label6.text = "infoLabel6".localized
    }


}
