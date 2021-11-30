//
//  Checker.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 21.11.2021.
//

import Foundation

enum CheckerType: Int {
    case ordinary
    case king
}


class Checker: NSObject, NSCoding, NSSecureCoding {

    static var supportsSecureCoding: Bool = true

    let checkerColor: CheckerColor
    var checkerType: CheckerType
    var cellTag: Int

    init(checkerColor: CheckerColor, checkerType: CheckerType, cellTag: Int) {
        self.checkerColor = checkerColor
        self.checkerType = checkerType
        self.cellTag = cellTag
    }

    func encode(with coder: NSCoder) {
        coder.encode(checkerColor.rawValue, forKey: "checkerColor")
        coder.encode(checkerType.rawValue, forKey: "checkerType")
        coder.encode(cellTag, forKey: "cellTag")
    }

    required init?(coder: NSCoder) {
        self.checkerColor = CheckerColor(rawValue: coder.decodeInteger(forKey: "checkerColor"))!
        self.checkerType = CheckerType(rawValue: coder.decodeInteger(forKey: "checkerType"))!
        self.cellTag = coder.decodeInteger(forKey: "cellTag")
    }
}
