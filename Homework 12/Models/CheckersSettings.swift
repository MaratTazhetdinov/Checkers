//
//  CheckersData.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 17.08.2021.
//

import UIKit

class CheckersSettings: NSObject, NSCoding, NSSecureCoding {
    
    static var supportsSecureCoding: Bool = true
    
    static var shared: CheckersSettings = {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("CheckersData")
        if let data = FileManager.default.contents(atPath: fileURL.absoluteString.replacingOccurrences(of: "file://", with: "")),
           let object = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? CheckersSettings {
            return object
        }
        return CheckersSettings()
    }()
    
    private override init() {}
    
    var deskImage: UIImage! = UIImage(named: "Table")
    var checkersStyle: Int = 0
    var currentLanguage: String = "en"

    func save() {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("CheckersData")
        try? data?.write(to: fileURL)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(deskImage.pngData(), forKey: "deskImage")
        coder.encode(checkersStyle, forKey: "checkerStyle")
        coder.encode(currentLanguage, forKey: "currentLanguage")
    }
    
    required init?(coder: NSCoder) {
        let imageData = coder.decodeObject(forKey: "deskImage") as! Data
        self.deskImage = UIImage(data: imageData)
        self.checkersStyle = coder.decodeInteger(forKey: "checkerStyle")
        if coder.containsValue(forKey: "currentLanguage") {
            self.currentLanguage = coder.decodeObject(forKey: "currentLanguage") as! String
        }
    }
}
