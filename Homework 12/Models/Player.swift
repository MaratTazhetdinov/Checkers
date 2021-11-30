//
//  Player.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 21.11.2021.
//

import Foundation

class Player: NSObject, NSCoding, NSSecureCoding
{

    static var supportsSecureCoding: Bool = true
    
    var name: String?
    var checkerColor: CheckerColor.RawValue?
    var checkerStyle: String?
    var winner: Bool?
    
    init(name: String, checkerColor: CheckerColor.RawValue) {
        super.init()
        self.name = name
        self.checkerColor = checkerColor
    }
    
    func encode(with coder: NSCoder) {
        if let name = name {
            coder.encode(name, forKey: "name")
        }
        if let checkerColor = checkerColor {
            coder.encode(checkerColor, forKey: "playerCheckerColor")
        }
        if let winner = winner {
            coder.encode(winner, forKey: "winner1")
        }
        if let checkerStyle = checkerStyle {
            coder.encode(checkerStyle, forKey: "checkerStyle")
        }
    }
    
    required init?(coder: NSCoder) {
        if coder.containsValue(forKey: "name") {
            self.name = coder.decodeObject(forKey: "name") as? String
        }
        if coder.containsValue(forKey: "playerCheckerColor") {
            self.checkerColor = coder.decodeInteger(forKey: "playerCheckerColor")
        }
        if coder.containsValue(forKey: "winner") {
            self.winner = coder.decodeBool(forKey: "winner")
        }
        if coder.containsValue(forKey: "name") {
            self.name = coder.decodeObject(forKey: "checkerStyle") as? String
        }
    }
}
