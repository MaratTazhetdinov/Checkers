//
//  UIViewController+CoreKit.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 27.07.2021.
//

import UIKit

extension UIViewController {
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @discardableResult
    func presentAlertController(with title: String?, message: String?, useTextField: Bool = false, preferredStyle: UIAlertController.Style = .alert, actions: UIAlertAction...) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if useTextField, preferredStyle == .alert { alert.addTextField { _ in } }
        
        actions.forEach { alert.addAction($0) }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        return alert
    }
    
    @discardableResult
    func presentOkAlertController(with title: String?, message: String?, useTextField: Bool = false, preferredStyle: UIAlertController.Style = .alert, actions: UIAlertAction...) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        if useTextField, preferredStyle == .alert { alert.addTextField { _ in } }
        
        actions.forEach { alert.addAction($0) }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        return alert
    }
}
