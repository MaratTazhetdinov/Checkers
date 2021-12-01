//
//  PlayerCD+CoreDataProperties.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 30.11.2021.
//
//

import Foundation
import CoreData


extension PlayerCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerCD> {
        return NSFetchRequest<PlayerCD>(entityName: "PlayerCD")
    }

    @NSManaged public var name: String?
    @NSManaged public var checkerStyle: String?
    @NSManaged public var winner: Bool
    @NSManaged public var game: GameCD?
    
    func convert(by player: Player) {
        self.name = player.name
        self.checkerStyle = player.checkerStyle
        self.winner = player.winner!
    }

}

extension PlayerCD : Identifiable {

}
