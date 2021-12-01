//
//  GameCD+CoreDataProperties.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 30.11.2021.
//
//

import Foundation
import CoreData


extension GameCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameCD> {
        return NSFetchRequest<GameCD>(entityName: "GameCD")
    }

    @NSManaged public var date: String?
    @NSManaged public var players: NSSet?

}

// MARK: Generated accessors for players
extension GameCD {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: PlayerCD)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: PlayerCD)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)

}

extension GameCD : Identifiable {

}
