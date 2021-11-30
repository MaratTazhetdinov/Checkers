//
//  Player_CD+CoreDataProperties.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 28.11.2021.
//
//

import Foundation
import CoreData


extension Player_CD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player_CD> {
        return NSFetchRequest<Player_CD>(entityName: "Player_CD")
    }

    @NSManaged public var name: String?
    @NSManaged public var checkerStyle: String?
    @NSManaged public var winner: Bool
    @NSManaged public var game: Game_CD?
    
    func convert(by player: Player) {
        self.name = player.name
        self.checkerStyle = player.checkerStyle
        self.winner = player.winner!
    }

}

extension Player_CD : Identifiable {

}
