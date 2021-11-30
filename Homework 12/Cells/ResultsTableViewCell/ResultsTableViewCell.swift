//
//  ResultsTableViewCell.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 30.11.2021.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var player1Name: UILabel!
    @IBOutlet weak var player2Name: UILabel!
    @IBOutlet weak var player1Checker: UIImageView!
    @IBOutlet weak var player2Checker: UIImageView!
    @IBOutlet weak var player1Trophy: UIImageView!
    @IBOutlet weak var player2Trophy: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        self.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.backgroundView = blurEffectView
    }
    
    func configure(player1Name: String, player2Name: String, player1Checker: String, player2Checker: String, player1Winner: Bool, date: String) {
        
        self.player1Name.text = player1Name
        self.player2Name.text = player2Name
        self.player1Checker.image = UIImage(named: player1Checker)
        self.player2Checker.image = UIImage(named: player2Checker)
        dateLabel.text = date
        
        if player1Winner {
            self.player2Trophy.isHidden = true
        } else {
            self.player1Trophy.isHidden = true
        }
    }
}
