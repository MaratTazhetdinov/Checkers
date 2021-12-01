//
//  CoreDataManager.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 30.11.2021.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Homework 12")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("SAVED")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addNewGame(by game: GameData) {
        let gameCD = GameCD(context: persistentContainer.viewContext)
        gameCD.date = game.gameDate
        
        let firstPlayerCD = PlayerCD(context: persistentContainer.viewContext)
        firstPlayerCD.convert(by: game.player1!)
        gameCD.addToPlayers(firstPlayerCD)
        
        let secondPlayerCD = PlayerCD(context: persistentContainer.viewContext)
        secondPlayerCD.convert(by: game.player2!)
        gameCD.addToPlayers(secondPlayerCD)
        
        persistentContainer.viewContext.insert(gameCD)
        saveContext()
    }
    
    func getGames() -> [GameData] {
        var array: [GameData] = []
        do {
            let games = try persistentContainer.viewContext.fetch(GameCD.fetchRequest())
            for game in games {
                array.append(GameData(from: game))
            }
//            games.forEach { game in
//                guard let game = game as? GameCD else { return }
//                array.append(GameData(from: game))
//            }
        } catch (let e) {
            print(e)
        }
        return array
    }
    
    func deleteGames() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "GameCD")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        }
        catch {
            print(error)
        }
    }
  
}
