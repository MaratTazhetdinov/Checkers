//
//  Player.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 21.11.2021.
//

import Foundation

class Player {
    
    let name: String
    let checkerColor: CheckerColor
    var checkerCount: Int = 12
    var winner: Bool?
    
    init(name: String, checkerColor: CheckerColor) {
        self.name = name
        self.checkerColor = checkerColor
    }
}
