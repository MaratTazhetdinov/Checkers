//
//  ResultsViewController.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 25.07.2021.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    private var games: [GameData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localized()
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        tableView.dataSource = self
        tableView.separatorColor = .gray
        tableView.separatorStyle = .singleLine
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = blurEffectView
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: "ResultsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        backButton.addBorder(with: .black, borderWidth: 3.0)
        backButton.layer.cornerRadius = backButton.frame.size.height / 4.5
        
        removeButton.addBorder(with: .black, borderWidth: 3.0)
        
        games = CoreDataManager.shared.getGames()
        self.tableView.reloadData()
    }
    
    func localized() {
        backButton.setTitle("backMainMenuLabel".localized, for: .normal)
        resultsLabel.text = "resultsLabel".localized
    }
    
    @IBAction func removeActionButton(_ sender: Any) {
        CoreDataManager.shared.deleteGames()
        games = []
        tableView.reloadData()
    }
}

extension ResultsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ResultsTableViewCell
        cell.configure(gameData: self.games[indexPath.row])
        return cell
    }
}

