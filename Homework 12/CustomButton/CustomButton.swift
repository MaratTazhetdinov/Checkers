//
//  CustomButton.swift
//  Homework 12
//
//  Created by Marat Tazhetdinov on 15.08.2021.
//

import UIKit

protocol CustomButtonDelegate: AnyObject {
    func customButtonDidTap(_sender: CustomButton)
}

@IBDesignable
class CustomButton : UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    @IBInspectable var cornerRadius: CGFloat {
        set { contentView.layer.cornerRadius = newValue }
        get { return contentView.layer.cornerRadius }
    }
    
    @IBInspectable var borderCornerRadius: CGFloat {
        set { self.layer.cornerRadius = newValue }
        get { return self.layer.cornerRadius }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set { self.layer.borderWidth = newValue }
        get { return self.layer.borderWidth }
    }
    
    @IBInspectable var borderColor: UIColor {
        set { self.layer.borderColor = newValue.cgColor }
        get {
            if let cgColor = self.layer.borderColor {
                return UIColor(cgColor: cgColor)
            }
            return .clear
        }
    }
    
    @IBInspectable var text: String {
        set { self.label.text = newValue }
        get { return self.label.text ?? "" }
    }
    
    @IBInspectable var imageName: String {
        set { self.imageView.image = UIImage(named: newValue)}
        get { return self.imageName}
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    weak var delegate:CustomButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup () {
        Bundle(for: CustomButton.self).loadNibNamed("CustomButton", owner: self, options: nil)
        contentView.frame = self.bounds
        self.addSubview(contentView)
    }
    
    
    
    @IBAction func customButtonAction(_ sender: UIButton) {
        delegate?.customButtonDidTap(_sender: self)
    }
    
}
