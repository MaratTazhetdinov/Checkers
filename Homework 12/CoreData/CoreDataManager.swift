//
//  CoreDataManager.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 28.11.2021.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Homework_12")
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
        let game_CD = Game_CD(context: persistentContainer.viewContext)
        game_CD.date = game.gameDate
        
        let player1 = Player_CD(context: persistentContainer.viewContext)
        player1.convert(by: game.player1!)
        game_CD.addToPlayer(player1)
        
        let player2 = Player_CD(context: persistentContainer.viewContext)
        player2.convert(by: game.player2!)
        game_CD.addToPlayer(player2)
        
        persistentContainer.viewContext.insert(game_CD)
    }
    
//    func getPlayers(by game: GameData) -> [Player] {
//        let requst: NSFetchRequest<Game_CD> = Game_CD.fetchRequest()
//        var players: [Player] = []
//
//        do {
//            guard let game_CD = try persistentContainer.viewContext.fetch(requst).first else { return [] }
//            game_CD.player?.allObjects.forEach({ player_CD in
//                guard let player_CD = player_CD as? Player_CD else { return }
//                let player = Player(name: player_CD.name!, checkerColor: 100)
//                player.checkerStyle = player_CD.checkerStyle
//                player.winner = player_CD.winner
//                players.append(player)
//            })
//            saveContext()
//        } catch (let e) {
//            print(e)
//        }
//
//        return players
//    }
    

    func getGame() -> [GameData] {
        var array: [GameData] = []
        
        
        
        do {
            let games = try persistentContainer.viewContext.fetch(Game_CD.fetchRequest())
            
            for game_CD in games {
                let game = GameData()
                game.gameDate = game_CD.date
                array.append(game)
                
            }

        } catch (let e) {
            print(e)
        }

        
        
        return array
    }
    
    
}
