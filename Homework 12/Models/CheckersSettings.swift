//
//  CheckersData.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 17.08.2021.
//

import UIKit

class CheckersSettings: NSObject, NSCoding, NSSecureCoding {
    
    static var supportsSecureCoding: Bool = true
    
    static let shared = CheckersSettings()
    
    var deskImage: UIImage! = UIImage(named: "Table")
    var checkersStyle: Int = 0

    
    override init() {
        super.init()
    }
    
    func getData () -> CheckersSettings {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("CheckersData")
        guard let data = FileManager.default.contents(atPath: fileURL.absoluteString.replacingOccurrences(of: "file://", with: "")) else {return CheckersSettings()}
        guard let object = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? CheckersSettings else {return CheckersSettings()}
        return object
    }
    
    func saveData (object: CheckersSettings) {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: true)
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("CheckersData")
        try? data?.write(to: fileURL)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(deskImage.pngData(), forKey: "deskImage")
        coder.encode(checkersStyle, forKey: "checkerStyle")
    }
    
    required init?(coder: NSCoder) {
        let imageData = coder.decodeObject(forKey: "deskImage") as! Data
        self.deskImage = UIImage(data: imageData)
        self.checkersStyle = coder.decodeInteger(forKey: "checkerStyle")
    }
}
 
       
        
    

