//
//  UIView+CoreKit.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 27.07.2021.
//

import UIKit

extension UIView {
    
    func addBorder (with borderColor: UIColor, borderWidth: CGFloat){
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
    
    func addShadow (with color: UIColor, opacity: Float, shadowOffset: CGSize) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = shadowOffset
    }
}
