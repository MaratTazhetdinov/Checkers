//
//  GameData.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 27.11.2021.
//

import Foundation
import CoreData

class GameData: NSObject, NSCoding, NSSecureCoding {

    static var supportsSecureCoding: Bool = true
    
    var player1: Player?
    var player2: Player?
    var gameTimeMin: Int?
    var gameTimeSec: Int?
    var gameDate: String?
    var checkersArray: [Checker]?
    var currentColor: CheckerColor?
    var notCurrentColor: CheckerColor?
    
    override init() {
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        if let player1 = player1 {
            coder.encode(player1, forKey: "player1")
        }
        if let player2 = player2 {
            coder.encode(player2, forKey: "player2")
        }
        if let gameTimeMin = gameTimeMin {
            coder.encode(gameTimeMin, forKey: "gameTimeMin")
        }
        if let gameTimeSec = gameTimeSec {
            coder.encode(gameTimeSec, forKey: "gameTimeSec")
        }
        if let gameDate = gameDate {
            coder.encode(gameDate, forKey: "gameDate")
        }
        if let checkersArray = checkersArray {
            coder.encode(checkersArray, forKey: "checkersArray")
        }
        if let currentColor = currentColor {
            coder.encode(currentColor.rawValue, forKey: "currentColor")
        }
        if let notCurrentColor = notCurrentColor {
            coder.encode(notCurrentColor.rawValue, forKey: "notCurrentColor")
        }
    }
    
    required init?(coder: NSCoder) {
        if coder.containsValue(forKey: "player1") {
            self.player1 = coder.decodeObject(forKey: "player1") as? Player
        }
        if coder.containsValue(forKey: "player2") {
            self.player2 = coder.decodeObject(forKey: "player2") as? Player
        }
        if coder.containsValue(forKey: "gameTimeMin") {
            self.gameTimeMin = coder.decodeInteger(forKey: "gameTimeMin")
        }
        if coder.containsValue(forKey: "gameTimeSec") {
            self.gameTimeSec = coder.decodeInteger(forKey: "gameTimeSec")
        }
        if coder.containsValue(forKey: "gameDate") {
            self.gameDate = coder.decodeObject(forKey: "gameDate") as? String
        }
        if coder.containsValue(forKey: "checkersArray") {
            self.checkersArray = (coder.decodeObject(forKey: "checkersArray") as? [Checker]) ?? []
        }
        if coder.containsValue(forKey: "currentColor") {
            self.currentColor = CheckerColor(rawValue: coder.decodeInteger(forKey: "currentColor"))
        }
        if coder.containsValue(forKey: "currentColor") {
            self.notCurrentColor = CheckerColor(rawValue: coder.decodeInteger(forKey: "notCurrentColor"))
        }
    }
    
    static func getData() -> GameData? {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("GameData")
        guard let data = FileManager.default.contents(atPath: fileURL.absoluteString.replacingOccurrences(of: "file://", with: "")) else {return nil}
        guard let object = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? GameData else {return nil}
        return object
    }
    
    func save() {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("GameData")
        try? data?.write(to: fileURL)
    }
    
    func delete() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("GameData")
        try? FileManager.default.removeItem(atPath: fileURL.path)
    }

    
}
