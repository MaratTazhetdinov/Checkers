//
//  GameViewController.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 25.07.2021.
//

import UIKit

enum CheckerColor: Int {
    case white = 100
    case black = 101
}

class GameViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerBackground: UIView!
    @IBOutlet weak var chessTable: UIImageView!
    @IBOutlet weak var gameInfoView: UIView!
    @IBOutlet weak var currentCheckerImage: UIImageView!
    @IBOutlet weak var currentPlayer: UILabel!
    
    var chessboard: UIView!
    var board: UIImageView!
    var timer: Timer?
    var countSeconds: Int = 0
    var countMinutes: Int = 0
    var startAnimationView: UIImageView!
    var currentColor: CheckerColor = .white
    var notCurrentColor: CheckerColor = .black
    var image: UIImage?
    var checkersArray = [Checker]()
    var mustAttack: Int = 0
    
    let arrayOfLines: [[Int]] = [ [1, 5],
                                  [1, 6, 10, 15, 19, 24, 28],
                                  [2, 6, 9, 13],
                                  [2, 7, 11, 16, 20],
                                  [3, 8, 12],
                                  [3, 7, 10, 14, 17, 21],
                                  [4, 8, 11, 15, 18, 22, 25, 29],
                                  [5, 9, 14, 18, 23, 27, 32],
                                  [12, 16, 19, 23, 26, 30],
                                  [13, 17, 22, 26, 31],
                                  [20, 24, 27, 31],
                                  [21, 25, 30],
                                  [28, 32] ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChessTable()
        createChessboard()
        view.addSubview(setupAnimation())
        setupTimer()
        changePlate()
        let result = checkAttack(cellTag: 5)
        print(result)
    }
    
    func changePlate() {
        if currentColor == .white {
            currentCheckerImage.image = UIImage(named: "WhiteChecker\(CheckersSettings.shared.getData().checkersStyle)")
        } else {
            currentCheckerImage.image = UIImage(named: "BlackChecker\(CheckersSettings.shared.getData().checkersStyle)")
        }
    }
    


    
    @objc func panGesture(_ sender: UIPanGestureRecognizer) {
        
        var availableMove: [Int] = []
        var actionType: String
        
        guard sender.view?.tag == currentColor.rawValue, let cellTag = sender.view?.superview?.tag else {return}
        
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

        let location = sender.location(in: chessboard)
        let translation = sender.translation(in: chessboard)

        switch sender.state {
        case .began:
            UIImageView.animate(withDuration: 0.3){
                sender.view?.transform = self.view.transform.scaledBy(x: 1.4, y: 1.4)
            }
            
        case .changed:
            guard let column = sender.view?.superview, let cellOrigin = sender.view?.frame.origin else { return }
            chessboard.bringSubviewToFront(column)
            sender.view?.frame.origin = CGPoint(x: cellOrigin.x + translation.x,
                                                y: cellOrigin.y + translation.y)
            sender.setTranslation(.zero, in: chessboard)
            for value in availableMove {
                chessboard.viewWithTag(value)?.addBorder(with: .yellow, borderWidth: 3.0)
            }
            
        case .ended:
            
            let currentCell = chessboard.subviews.first(where: {$0.frame.contains(location) && availableMove.contains($0.tag)})
            
            UIImageView.animate(withDuration: 0.3) {
                sender.view?.transform = .identity
            }
            sender.view?.frame.origin = CGPoint(x: 5, y: 5)
            
            guard let newCell = currentCell, newCell.subviews.isEmpty, let cell = sender.view else { return }
            
            newCell.addSubview(cell)
            
            if isKing(cellTag: cellTag) {
                actionType = detectActionKing(before: cellTag, after: newCell.tag)
            } else {
                actionType = detectAction(before: cellTag, after: newCell.tag)
            }
        
            if actionType == "Attack" {
                if checkAttack(cellTag: newCell.tag).isEmpty && checkAttackKing(cellTag: newCell.tag).isEmpty {
                    currentColor = currentColor == .white ? .black : .white
                    notCurrentColor = notCurrentColor == .white ? .black : .white
                    mustAttack = 0
                } else if !checkAttack(cellTag: newCell.tag).isEmpty {
                    mustAttack = newCell.tag
                }
            } else {
                currentColor = currentColor == .white ? .black : .white
                notCurrentColor = notCurrentColor == .white ? .black : .white
                mustAttack = 0
            }
            
            changeTags(before: cellTag, after: newCell.tag)
            becameKing()
            clearBoarder()
            changePlate()
            checkWinner()

        default:
            break
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
        if whiteCount == 0 {
            presentAlertController(with: nil,
                                   message: "Black Wins",
                                   preferredStyle: .alert)
        }
        if blackCount == 0 {
            presentAlertController(with: nil,
                                   message: "White Wins",
                                   preferredStyle: .alert)
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
        if whiteActions == [] {
            presentAlertController(with: nil,
                                   message: "Black Wins",
                                   preferredStyle: .alert)
        }
        if blackActions == [] {
            presentAlertController(with: nil,
                                   message: "White Wins",
                                   preferredStyle: .alert)
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
                king.image = UIImage(named: "whiteCrown\(CheckersSettings.shared.getData().checkersStyle)")
                checker.checkerType = .king
            }
            if endLineBlack.contains(checker.cellTag) && checker.checkerColor == .black {
                guard let king: UIImageView = chessboard.viewWithTag(checker.cellTag)?.viewWithTag(checker.checkerColor.rawValue) as? UIImageView else {return}
                king.image = UIImage(named: "blackCrown\(CheckersSettings.shared.getData().checkersStyle)")
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
        
        guard sender.view?.tag == currentColor.rawValue else {return}
        guard let cellTag = sender.view?.superview?.tag else {return}
        if checkArrayForAttack() != [] {
            let array = checkArrayForAttack()
            guard array.contains(cellTag) else {return}
        }
        switch sender.state {
        case .began:
            UIView.animate(withDuration: 0.3) {
                sender.view?.transform = sender.view!.transform.scaledBy(x: 1.4, y: 1.4)
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

extension GameViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.addBorder(with: .black, borderWidth: 3.0)
        timerBackground.addBorder(with: .white, borderWidth: 3.0)
        backButton.layer.cornerRadius = backButton.frame.size.height / 4.5
        timerBackground.layer.cornerRadius = timerBackground.frame.size.height / 4.5
        gameInfoView.layer.cornerRadius = gameInfoView.frame.size.height / 2.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer?.invalidate()
    }
    
    func setupChessTable() {
        chessTable.image = CheckersSettings.shared.getData().deskImage
        chessTable.contentMode = .scaleAspectFill
    }
    
    func setupAnimation() -> UIImageView {
        startAnimationView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.size.width - 80, height: (view.bounds.size.width - 80)/2)))
        startAnimationView.center = view.center
        startAnimationView.image = UIImage(named: "5ca369266e9645e3bcaea294e09e9600sXBI9AVtt8UCyiA4-0")
        startAnimationView.animationImages = getArrayImages()
        startAnimationView.contentMode = .scaleAspectFit
        startAnimationView.animationRepeatCount = 1
        startAnimationView.animationDuration = 2.0
        startAnimationView.startAnimating()
        return startAnimationView
    }
    
    func setupTimer(){
        timerLabel.text = "0\(countMinutes) : 0\(countSeconds)"
        timer = Timer(timeInterval: 1, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    @objc func timerFunc(){
        countSeconds += 1
        if countSeconds > 59 {
            countMinutes += 1
            countSeconds = 0
        }
        switch countSeconds {
        case 0...9:
            if countMinutes <= 9 {
                timerLabel.text = "0\(countMinutes) : 0\(countSeconds)"
            } else {
                timerLabel.text = "\(countMinutes) : 0\(countSeconds)"
            }
        default:
            if countMinutes > 9 {
                timerLabel.text = "\(countMinutes) : \(countSeconds)"
            } else {
                timerLabel.text = "0\(countMinutes) : \(countSeconds)"
            }
        }
    }
    
    func createChessboard() {
        
        let size = view.bounds.size.width - 48
        chessboard = UIView(frame: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
        board = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size + 24, height: size + 24)))
        board.image = UIImage(named: "Board")
        view.addSubview(board)
        board.center = view.center
        var blackCellsTagCount = 1
        
        let sizeColumn = size / 8
        for i in 0..<8 {
            for j in 0..<8 {
                let column = UIImageView(frame: CGRect(x: sizeColumn * CGFloat (j),
                                                  y: sizeColumn * CGFloat (i),
                                                  width: sizeColumn,
                                                  height: sizeColumn))
                
                if (i+j) % 2 == 0 {
                    column.image = UIImage(named: "WhiteCell")
                } else {
                    column.image = UIImage(named: "BlackCell")
                    column.backgroundColor = .black
                    column.tag = blackCellsTagCount
                    blackCellsTagCount += 1
                }
                
                column.isUserInteractionEnabled = true
                chessboard.addSubview(column)
                
                guard column.backgroundColor == .black else { continue }

                switch column.tag {
                case 1...12:
                    let checker: Checker = Checker(checkerColor: .black, checkerType: .ordinary, cellTag: column.tag)
                    checkersArray.append(checker)
                    let checkerImage = UIImageView(frame: CGRect (x: 5, y: 5, width: sizeColumn - 10, height: sizeColumn - 10))
                    checkerImage.isUserInteractionEnabled = true
                    checkerImage.image = UIImage(named: "BlackChecker\(CheckersSettings.shared.getData().checkersStyle)")
                    checkerImage.tag = checker.checkerColor.rawValue
                    column.addSubview(checkerImage)
                    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
                    panGesture.delegate = self
                    checkerImage.addGestureRecognizer(panGesture)

                    let longTapGesture = UILongPressGestureRecognizer (target: self, action: #selector(longTapRecognizer(_:)))
                    longTapGesture.minimumPressDuration = 0.1
                    longTapGesture.delegate = self
                    checkerImage.addGestureRecognizer(longTapGesture)

                case 21...32:
                    let checker: Checker = Checker(checkerColor: .white, checkerType: .ordinary, cellTag: column.tag)
                    checkersArray.append(checker)
                    let checkerImage = UIImageView(frame: CGRect (x: 5, y: 5, width: sizeColumn - 10, height: sizeColumn - 10))
                    checkerImage.isUserInteractionEnabled = true
                    checkerImage.image = UIImage(named: "WhiteChecker\(CheckersSettings.shared.getData().checkersStyle)")
                    checkerImage.tag = checker.checkerColor.rawValue
                    column.addSubview(checkerImage)
                    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
                    panGesture.delegate = self
                    checkerImage.addGestureRecognizer(panGesture)
                    let longTapGesture = UILongPressGestureRecognizer (target: self, action: #selector(longTapRecognizer(_:)))
                    longTapGesture.minimumPressDuration = 0.1
                    longTapGesture.delegate = self
                    checkerImage.addGestureRecognizer(longTapGesture)
                default:
                    continue
                }
            }
        }
        view.addSubview(chessboard)
        chessboard.center = view.center
    }
    
    func getArrayImages() -> [UIImage] {
        var array: [UIImage] = []
        for i in 0...39 {
            guard let image = UIImage(named: "5ca369266e9645e3bcaea294e09e9600sXBI9AVtt8UCyiA4-\(i)") else { continue }
            array.append(image)
        }
        return array
    }
    
    
    @IBAction func backButtonAlertAction(_ sender: Any) {
        presentAlertController(with: nil,
                               message: "Do you want to save the game?",
                               preferredStyle: .alert,
                               actions: UIAlertAction(title: "Save and quit", style: .default,
                                                      handler: { _ in
                                                        self.navigationController!.popToRootViewController(animated: true)
                                                        }),
                               UIAlertAction(title: "Don't save and quit", style: .default,
                                                      handler: { _ in
                                                        self.navigationController!.popToRootViewController(animated: true)
                                                        })
                               )
    }

}

extension GameViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
