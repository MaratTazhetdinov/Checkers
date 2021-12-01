//
//  GameViewController.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 25.07.2021.
//

import UIKit
import AVFoundation

enum CheckerColor: Int {
    case white = 100
    case black = 101
}

class GameViewController: UIViewController {
    
    var game: GameData?

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerBackground: UIView!
    @IBOutlet weak var chessTable: UIImageView!
    @IBOutlet weak var gameInfoView: UIView!
    @IBOutlet weak var currentCheckerImage: UIImageView!
    @IBOutlet weak var currentPlayer: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateContainerView: UIView!
    
    var chessboard: UIView!
    var board: UIImageView!
    var timer: Timer?
    var countSeconds: Int = 0
    var countMinutes: Int = 0
    var startAnimationView: UIImageView!
    var currentColor: CheckerColor = .white
    var notCurrentColor: CheckerColor = .black
    var image: UIImage?
    var date: String = ""
    var audioPlayer: AVAudioPlayer?
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

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localized()
        setupChessTable()
        setDate()
        createGame()
        setupTimerAndAnimation()
        playMusic()
        changePlate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.addBorder(with: .black, borderWidth: 3.0)
        timerBackground.addBorder(with: .white, borderWidth: 3.0)
        backButton.layer.cornerRadius = backButton.frame.size.height / 4.5
        timerBackground.layer.cornerRadius = timerBackground.frame.size.height / 4.5
        gameInfoView.layer.cornerRadius = gameInfoView.frame.size.height / 2.0
        dateContainerView.addBorder(with: .white, borderWidth: 3.0)
        dateContainerView.layer.cornerRadius = dateContainerView.frame.size.height / 4.5
    }
    
    func playMusic() {
        let pathToMusic = Bundle.main.path(forResource: "mainTheme", ofType: "mp3")!
        let url = URL(fileURLWithPath: pathToMusic)
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
        audioPlayer?.numberOfLoops = -1
    }
    
    func setupTimerAndAnimation() {
        if countSeconds != 0 || countMinutes != 0 {
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
        } else {
            view.addSubview(setupAnimation())
            timerLabel.text = "0\(countMinutes) : 0\(countSeconds)"
        }
        setupTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer?.invalidate()
    }
    
    func detectPlayer(color: CheckerColor) -> String {
        
        var name: String
        
        if game?.player1?.checkerColor == color.rawValue {
            name = game?.player1?.name ?? ""
        } else {
            name = game?.player2?.name ?? ""
        }
        return name
    }
    
    func setDate() {
        if game?.gameDate == nil {
            game?.updateDate()
        }
        if let gameDate = game?.gameDate {
            date = gameDate
            dateLabel.text = "dateLabel".localized + date
        }
    }
    
    func localized() {
        backButton.setTitle("backMainMenuLabel".localized, for: .normal)
    }
    
    func setupGameData() {
        guard let array = game?.checkersArray,
              let seconds = game?.gameTimeSec,
              let minutes = game?.gameTimeMin,
              let current = game?.currentColor,
              let notCurrent = game?.notCurrentColor else { return }
        
        checkersArray = array
        countSeconds = seconds
        countMinutes = minutes
        currentColor = current
        notCurrentColor = notCurrent
    }
    
    func createGame() {
        setupGameData()
        if checkersArray.isEmpty {
            createChessboard()
        } else {
            createChessboardFromGameData()
        }
    }
    

    
    


    
    
    
    
}

extension GameViewController {
    
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
            clearBoarder()
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
            changePlate()
            checkWinner()

        default:
            break
        }
    }
    

    func setupChessTable() {
        chessTable.image = CheckersSettings.shared.deskImage
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
                    checkerImage.image = UIImage(named: "BlackChecker\(CheckersSettings.shared.checkersStyle)")
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
                    checkerImage.image = UIImage(named: "WhiteChecker\(CheckersSettings.shared.checkersStyle)")
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
    
    func createChessboardFromGameData() {
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

                for checker in checkersArray {
                    if checker.cellTag == column.tag {
                        let checkerImage = UIImageView(frame: CGRect (x: 5, y: 5, width: sizeColumn - 10, height: sizeColumn - 10))
                        checkerImage.isUserInteractionEnabled = true
                        if checker.checkerColor == .white  {
                            if checker.checkerType == .ordinary {
                                checkerImage.image = UIImage(named: "WhiteChecker\(CheckersSettings.shared.checkersStyle)")
                            } else {
                                checkerImage.image = UIImage(named: "whiteCrown\(CheckersSettings.shared.checkersStyle)")
                            }
                        } else {
                            if checker.checkerType == .ordinary {
                                checkerImage.image = UIImage(named: "BlackChecker\(CheckersSettings.shared.checkersStyle)")
                            } else {
                                checkerImage.image = UIImage(named: "blackCrown\(CheckersSettings.shared.checkersStyle)")
                            }
                        }
                        checkerImage.tag = checker.checkerColor.rawValue
                        column.addSubview(checkerImage)
                        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
                        panGesture.delegate = self
                        checkerImage.addGestureRecognizer(panGesture)
                        let longTapGesture = UILongPressGestureRecognizer (target: self, action: #selector(longTapRecognizer(_:)))
                        longTapGesture.minimumPressDuration = 0.1
                        longTapGesture.delegate = self
                        checkerImage.addGestureRecognizer(longTapGesture)
                    }
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
                               message: "backButtonAlertMessage".localized,
                               preferredStyle: .alert,
                               actions: UIAlertAction(title: "saveAlert".localized, style: .default,
                                                      handler: { _ in
                                                        self.game?.gameTimeSec = self.countSeconds
                                                        self.game?.gameTimeMin = self.countMinutes
                                                        self.game?.gameDate = self.date
                                                        self.game?.currentColor = self.currentColor
                                                        self.game?.notCurrentColor = self.notCurrentColor
                                                        self.game?.checkersArray = self.checkersArray
                                                        self.game?.save()
                                                        self.navigationController!.popToRootViewController(animated: true)
                                                        }),
                               UIAlertAction(title: "notSaveAlert".localized, style: .default,
                                                      handler: { _ in
                                                        self.game?.delete()
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
