//
//  CheckerStyleCollectionViewCell.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 18.08.2021.
//

import UIKit

class CheckerStyleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageCheck: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup (with imageName1: String, imageName2: String) {
        imageView1.image = UIImage(named: imageName1)
        imageView2.image = UIImage(named: imageName2)
    }
    
    func toggleSelected() {
        if isSelected == true {
            self.imageCheck.isHidden = false
        }
        else {
            self.imageCheck.isHidden = true
        }
    }
}
