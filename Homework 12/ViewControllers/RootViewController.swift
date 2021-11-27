//
//  ViewController.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 25.07.2021.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet var buttons: [CustomButton]!
    
    let vcIDs: [String] = ["GameViewController", "ResultsViewController", "SettingsViewController"]

    override func viewDidLoad() {
        super.viewDidLoad()

        for index in 0..<buttons.count {
            buttons[index].delegate = self
        }
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func getViewController (from id: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let currentViewController = storyboard.instantiateViewController(withIdentifier: id)
        return currentViewController
    }
}

extension RootViewController: CustomButtonDelegate {
    
    func customButtonDidTap(_sender sender: CustomButton) {
        guard let vc = getViewController(from: vcIDs[sender.tag]) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

