//
//  String+Localized.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 28.11.2021.
//

import Foundation

extension String {
    var localized: String {
        guard let languagePath = Bundle.main.path(forResource: CheckersSettings.shared.currentLanguage, ofType: "lproj"), let languageBundle = Bundle(path: languagePath) else { return self }
        
        return NSLocalizedString(self, bundle: languageBundle, value: "", comment: "")
    }
}
