//
//  Checker.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 21.11.2021.
//

import Foundation

enum CheckerType {
    case ordinary
    case king
}

class Checker {
    
    let checkerColor: CheckerColor
    var checkerType: CheckerType
    var cellTag: Int
    
    init(checkerColor: CheckerColor, checkerType: CheckerType, cellTag: Int) {
        self.checkerColor = checkerColor
        self.checkerType = checkerType
        self.cellTag = cellTag
    }
}
