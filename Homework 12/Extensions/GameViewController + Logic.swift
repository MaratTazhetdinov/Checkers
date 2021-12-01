//
//  GameViewController + Logic.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 27.11.2021.
//

import UIKit

extension GameViewController {
    
    func changePlate() {
        guard let player1 = game?.player1, let player2 = game?.player2 else {return}
        if currentColor == .white {
            currentCheckerImage.image = UIImage(named: "WhiteChecker\(CheckersSettings.shared.checkersStyle)")
            currentPlayer.text = player1.checkerColor == 0 ? player1.name : player2.name
        } else {
            currentCheckerImage.image = UIImage(named: "BlackChecker\(CheckersSettings.shared.checkersStyle)")
            currentPlayer.text = player2.checkerColor == 1 ? player2.name : player1.name
        }
    }
    
    func detectWinner(color:CheckerColor) {
        if game?.player1?.checkerColor == color.rawValue {
            game?.player1?.winner = true
            game?.player2?.winner = false
        } else {
            game?.player1?.winner = false
            game?.player2?.winner = true
        }
    }
    
    func checkArrayForAttack() -> [Int] {
        var result: [Int] = []
        for checker in checkersArray {
            if checker.checkerType == .ordinary && checkAttack(cellTag: checker.cellTag) != [] && checker.checkerColor == currentColor {
                result.append(checker.cellTag)
            }
            if checker.checkerType == .king && checkAttackKing(cellTag: checker.cellTag) != [] && checker.checkerColor == currentColor {
                result.append(checker.cellTag)
            }
        }
        return result
    }
    
    func checkWinner() {
        var whiteCount = 0
        var blackCount = 0
        for checker in checkersArray {
            if checker.checkerColor == .white {
                whiteCount = whiteCount + 1
            } else {
                blackCount = blackCount + 1
            }
        }
        var whiteActions: [Int] = []
        var blackActions: [Int] = []
        for checker in checkersArray {
            if checker.checkerColor == .white && checker.checkerType == .king {
                whiteActions = whiteActions + checkAttackKing(cellTag: checker.cellTag) + checkMoveKing(cellTag: checker.cellTag)
            }
            if checker.checkerColor == .white && checker.checkerType == .ordinary {
                whiteActions = whiteActions + checkAttack(cellTag: checker.cellTag) + checkMove(cellTag: checker.cellTag, checkerColor: .white)
            }
            if checker.checkerColor == .black && checker.checkerType == .king {
                blackActions = blackActions + checkAttackKing(cellTag: checker.cellTag) + checkMoveKing(cellTag: checker.cellTag)
            }
            if checker.checkerColor == .black && checker.checkerType == .ordinary {
                blackActions = blackActions + checkAttack(cellTag: checker.cellTag) + checkMove(cellTag: checker.cellTag, checkerColor: .black)
            }
        }
        
        game?.updateDate()
        if whiteCount == 0 {
            timer?.invalidate()
            presentResultAlertController(with: nil,
                                         message: "\(detectPlayer(color: .black)) " + "winAlert".localized,
                                   preferredStyle: .alert,
                                   actions: UIAlertAction(title: "backMainMenuLabel".localized, style: .default, handler: { _ in
                                                                                    self.navigationController!.popToRootViewController(animated: true)
                                                                                    }))
            detectWinner(color: .black)
            CoreDataManager.shared.addNewGame(by: game!)
        }
        else if blackCount == 0 {
            timer?.invalidate()
            presentResultAlertController(with: nil,
                                   message: "\(detectPlayer(color: .white)) " + "winAlert".localized,
                                   preferredStyle: .alert,
                                   actions: UIAlertAction(title: "backMainMenuLabel".localized, style: .default, handler: { _ in
                                                                                    self.navigationController!.popToRootViewController(animated: true)
                                                                                    }))
            detectWinner(color: .white)
            CoreDataManager.shared.addNewGame(by: game!)
        }
        else if whiteActions == [] {
            timer?.invalidate()
            presentResultAlertController(with: nil,
                                   message: "\(detectPlayer(color: .black))" + "winAlert".localized,
                                   preferredStyle: .alert,
                                         actions: UIAlertAction(title: "backMainMenuLabel".localized, style: .default, handler: { _ in
                                                                                    self.navigationController!.popToRootViewController(animated: true)
                                                                                    }))
                                   detectWinner(color: .black)
            CoreDataManager.shared.addNewGame(by: game!)
        }
        else if blackActions == [] {
            timer?.invalidate()
            presentResultAlertController(with: nil,
                                   message: "\(detectPlayer(color: .white))" + "winAlert".localized,
                                   preferredStyle: .alert,
                                   actions: UIAlertAction(title: "backMainMenuLabel".localized, style: .default, handler: { _ in
                                                                                    self.navigationController!.popToRootViewController(animated: true)
                                                                                    }))
                                  detectWinner(color: .black)
            CoreDataManager.shared.addNewGame(by: game!)
        }
    }
    
    func detectAction(before: Int, after: Int) -> String {
        var step: Int
        if before - after < 0 {
            step = 1
        } else {
            step = -1
        }
        let lines = arrayOfLines.filter{$0.contains(after) && $0.contains(before)}
        let line = lines[0]
        for (index,value) in line.enumerated() {
            if value == before {
                if line[index+step] != after {
                    chessboard.viewWithTag(line[index+step])?.viewWithTag(notCurrentColor.rawValue)?.removeFromSuperview()
                    checkersArray = checkersArray.filter(){$0.cellTag != line[index+step]}
                    return "Attack"
                }
            }
        }
        return "Move"
    }
    
    func detectActionKing(before:Int, after: Int) -> String {
        let lines = arrayOfLines.filter{$0.contains(after) && $0.contains(before)}
        let line = lines[0]
        let index_1 = line.firstIndex(of: before)
        let index_2 = line.firstIndex(of: after)
        let count = checkersArray.count
        guard let i = index_1, let j = index_2 else {return ""}
        let a = i > j ? i : j
        let b = i > j ? j : i
        for (index,value) in line.enumerated() {
            if index > b && index < a {
                chessboard.viewWithTag(value)?.viewWithTag(notCurrentColor.rawValue)?.removeFromSuperview()
                checkersArray = checkersArray.filter(){$0.cellTag != value}
            }
        }
        if count != checkersArray.count {
            return "Attack"
        } else {
            return "Move"
        }
    }
    
    func isKing(cellTag: Int) -> Bool {
        for checker in checkersArray {
            if checker.cellTag == cellTag && checker.checkerType == .king {
                return true
            }
        }
        return false
    }
    
    func becameKing() {
        let endLineWhite = [1,2,3,4]
        let endLineBlack = [29,30,31,32]
        for checker in checkersArray {
            if endLineWhite.contains(checker.cellTag) && checker.checkerColor == .white {
                guard let king: UIImageView = chessboard.viewWithTag(checker.cellTag)?.viewWithTag(checker.checkerColor.rawValue) as? UIImageView else {return}
                king.image = UIImage(named: "whiteCrown\(CheckersSettings.shared.checkersStyle)")
                checker.checkerType = .king
            }
            if endLineBlack.contains(checker.cellTag) && checker.checkerColor == .black {
                guard let king: UIImageView = chessboard.viewWithTag(checker.cellTag)?.viewWithTag(checker.checkerColor.rawValue) as? UIImageView else {return}
                king.image = UIImage(named: "blackCrown\(CheckersSettings.shared.checkersStyle)")
                checker.checkerType = .king
            }
        }
    }
    
    func checkMove(cellTag: Int, checkerColor: CheckerColor) -> [Int] {
        var result: [Int] = []
        var step: Int
        if checkerColor == .white {
            step = -1
        } else {
            step = 1
        }
        let availableLines: [[Int]] = arrayOfLines.filter(){$0.contains(cellTag)}
        for line in availableLines {
            for (index,value) in line.enumerated() {
                if value == cellTag {
                    if index + step < line.count && index + step >= 0 {
                        if searchEmpty(cellTag: line[index+step]) {
                            result.append(line[index+step])
                        }
                    }
                }
            }
        }
        return result
    }
    
    func clearBoarder() {
        for value in chessboard.subviews {
            value.addBorder(with: .clear, borderWidth: 0.0)
        }
    }
    
    func changeTags(before: Int, after: Int) {
        for checker in checkersArray {
            if checker.cellTag == before {
                checker.cellTag = after
            }
        }
    }
    
    func checkAttack(cellTag: Int) -> [Int] {
        var result: [Int] = []
        let availableLines: [[Int]] = arrayOfLines.filter(){$0.contains(cellTag)}
        for line in availableLines {
            if let value = checkForwardAttack(cellTag: cellTag, array: line) {
                result.append(value)
            }
            if let value = checkBackAttack(cellTag: cellTag, array: line) {
                result.append(value)
            }
        }
        return result
    }
    
    func checkMoveKing(cellTag: Int) -> [Int] {
        var result: [Int] = []
        var availableLines: [[Int]] = arrayOfLines.filter(){$0.contains(cellTag)}
        if availableLines.count == 1 {
            availableLines.append(availableLines[0])
        }
        let index_1 = availableLines[0].firstIndex(of: cellTag)
        let index_2 = availableLines[1].firstIndex(of: cellTag)
        guard var i = index_1, var j = index_2 else {return result}
        while i + 1 < availableLines[0].count && searchEmpty(cellTag: availableLines[0][i+1]){
            result.append(availableLines[0][i+1])
            i = i + 1
        }
        while j + 1 < availableLines[1].count && searchEmpty(cellTag: availableLines[1][j+1]){
            result.append(availableLines[1][j+1])
            j = j + 1
        }
        guard var i = index_1, var j = index_2 else {return result}
        while i - 1 >= 0 && searchEmpty(cellTag: availableLines[0][i-1]){
            result.append(availableLines[0][i-1])
            i = i - 1
        }
        while j - 1 >= 0 && searchEmpty(cellTag: availableLines[1][j-1]){
            result.append(availableLines[1][j-1])
            j = j - 1
        }
        return result
    }
    
    func checkAttackKing(cellTag: Int) -> [Int] {
        var result: [Int] = []
        var result1: [Int] = []
        var result2: [Int] = []
        var result3: [Int] = []
        var result4: [Int] = []
        var availableLines: [[Int]] = arrayOfLines.filter(){$0.contains(cellTag)}
        if availableLines.count == 1 {
            availableLines.append(availableLines[0])
        }
        let index_1 = availableLines[0].firstIndex(of: cellTag)
        let index_2 = availableLines[1].firstIndex(of: cellTag)
        guard var i = index_1, var j = index_2, var x = index_1, var y = index_2 else {return result}
        
        while i + 1 < availableLines[0].count {
            if searchChecker(cellTag: availableLines[0][i+1], color: currentColor) {
                break
            } else if searchChecker(cellTag: availableLines[0][i+1], color: notCurrentColor) {
                if i + 2 < availableLines[0].count {
                    if searchEmpty(cellTag: availableLines[0][i+2]) {
                        result1.append(availableLines[0][i+2])
                        i = i + 1
                    } else {
                        break
                    }
                } else {
                    break
                }
            } else if !result1.isEmpty && searchEmpty(cellTag: availableLines[0][i+1]) {
                result1.append(availableLines[0][i+1])
                i = i + 1
            } else {
                i = i + 1
            }
        }
        
        while j + 1 < availableLines[1].count {
            if searchChecker(cellTag: availableLines[1][j+1], color: currentColor) {
                break
            } else if searchChecker(cellTag: availableLines[1][j+1], color: notCurrentColor) {
                if j + 2 < availableLines[1].count {
                    if searchEmpty(cellTag: availableLines[1][j+2]) {
                        result2.append(availableLines[1][j+2])
                        j = j + 1
                    } else {
                        break
                    }
                } else {
                    break
                }
            } else if !result2.isEmpty && searchEmpty(cellTag: availableLines[1][j+1]) {
                result2.append(availableLines[1][j+1])
                j = j + 1
            } else {
                j = j + 1
            }
        }
        
        while x - 1 >= 0 {
            if searchChecker(cellTag: availableLines[0][x-1], color: currentColor) {
                break
            } else if searchChecker(cellTag: availableLines[0][x-1], color: notCurrentColor) {
                if x - 2 >= 0 {
                    if searchEmpty(cellTag: availableLines[0][x-2]) {
                        result3.append(availableLines[0][x-2])
                        x = x - 1
                    } else {
                        break
                    }
                } else {
                    break
                }
            } else if !result3.isEmpty && searchEmpty(cellTag: availableLines[0][x-1]) {
                result3.append(availableLines[0][x-1])
                x = x - 1
            } else {
                x = x - 1
            }
        }
        
        while y - 1 >= 0 {
            if searchChecker(cellTag: availableLines[1][y-1], color: currentColor) {
                break
            } else if searchChecker(cellTag: availableLines[1][y-1], color: notCurrentColor) {
                if y - 2 >= 0 {
                    if searchEmpty(cellTag: availableLines[1][y-2]) {
                        result4.append(availableLines[1][y-2])
                        y = y - 1
                    } else {
                        break
                    }
                } else {
                    break
                }
            } else if !result4.isEmpty && searchEmpty(cellTag: availableLines[1][y-1]) {
                result4.append(availableLines[1][y-1])
                y = y - 1
            } else {
                y = y - 1
            }
        }
        
        result = result1 + result2 + result3 + result4
        return result
    }
    
    func checkForwardAttack(cellTag: Int, array: [Int]) -> Int? {
        var result: Int?
        for (index,value) in array.enumerated() {
            if value == cellTag {
                if index+1 < array.count && searchChecker(cellTag: array[index+1], color: notCurrentColor) {
                    if index+2 < array.count && searchEmpty(cellTag: array[index+2]) {
                        result = array[index+2]
                    }
                }
            }
        }
        return result
    }
    
    func checkBackAttack(cellTag: Int, array: [Int]) -> Int? {
        var result: Int?
        for (index,value) in array.enumerated() {
            if value == cellTag {
                if index-1 >= 0 && searchChecker(cellTag: array[index-1], color: notCurrentColor) {
                    if index-2 >= 0 && searchEmpty(cellTag: array[index-2]) {
                        result = array[index-2]
                    }
                }
            }
        }
        return result
    }
    
    func searchChecker(cellTag: Int, color: CheckerColor) -> Bool {
        for checker in checkersArray {
            if checker.cellTag == cellTag && checker.checkerColor == color {
                return true
            }
        }
        return false
    }
    
    func searchEmpty(cellTag:Int) -> Bool {
        for checker in checkersArray {
            if checker.cellTag == cellTag {
                return false
            }
        }
        return true
    }
    
    @objc func longTapRecognizer ( _ sender: UILongPressGestureRecognizer) {
        
        var availableMove: [Int] = []
        guard sender.view?.tag == currentColor.rawValue else {return}
        guard let cellTag = sender.view?.superview?.tag else {return}
        
        if mustAttack != 0 {
            guard cellTag == mustAttack else {return}
        }

        if checkArrayForAttack() != [] {
            let array = checkArrayForAttack()
            guard array.contains(cellTag) else {return}
        }
                
        if isKing(cellTag: cellTag) {
            availableMove = checkAttackKing(cellTag: cellTag)
            if availableMove.isEmpty {
                availableMove = checkMoveKing(cellTag: cellTag)
            }
        } else {
            availableMove = checkAttack(cellTag: cellTag)
            if availableMove.isEmpty {
                availableMove = checkMove(cellTag: cellTag, checkerColor: currentColor)
            }
        }
        
        switch sender.state {
        case .began:
            UIView.animate(withDuration: 0.3) {
                sender.view?.transform = sender.view!.transform.scaledBy(x: 1.4, y: 1.4)
            }
            for value in availableMove {
                chessboard.viewWithTag(value)?.addBorder(with: .yellow, borderWidth: 3.0)
            }
        case .ended:
            UIView.animate(withDuration: 0.3) {
                sender.view?.transform = .identity
            }
            clearBoarder()
        default:
            return
        }
    }
    
}
