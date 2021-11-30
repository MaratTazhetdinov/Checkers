//
//  Game_CD+CoreDataProperties.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 28.11.2021.
//
//

import Foundation
import CoreData


extension Game_CD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game_CD> {
        return NSFetchRequest<Game_CD>(entityName: "Game_CD")
    }

    @NSManaged public var date: String?
    @NSManaged public var player: NSSet?

}

// MARK: Generated accessors for player
extension Game_CD {

    @objc(addPlayerObject:)
    @NSManaged public func addToPlayer(_ value: Player_CD)

    @objc(removePlayerObject:)
    @NSManaged public func removeFromPlayer(_ value: Player_CD)

    @objc(addPlayer:)
    @NSManaged public func addToPlayer(_ values: NSSet)

    @objc(removePlayer:)
    @NSManaged public func removeFromPlayer(_ values: NSSet)

}

extension Game_CD : Identifiable {

}
