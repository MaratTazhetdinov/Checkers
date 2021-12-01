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
    
    func configure(gameData: GameData) {
        
        self.player1Name.text = gameData.player1?.name
        self.player2Name.text = gameData.player2?.name
        self.player1Checker.image = UIImage(named: (gameData.player1?.checkerStyle)!)
        self.player2Checker.image = UIImage(named: (gameData.player2?.checkerStyle)!)
        dateLabel.text = gameData.gameDate
        
        self.player1Trophy.alpha = (gameData.player2?.winner ?? false) ? 1 : 0
        self.player2Trophy.alpha = (gameData.player1?.winner ?? false) ? 1 : 0
    }
}
