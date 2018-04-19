//
//  LoginTextField.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/1.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

@IBDesignable
class LoginTextField: UITextField{
    
    // MARK: - IBInspectable
    @IBInspectable var tintCol: UIColor = UIColor(netHex: 0x333333)
    @IBInspectable var fontCol: UIColor = UIColor(netHex: 0x333333)
    @IBInspectable var shadowCol: UIColor = UIColor(netHex: 0x707070)
    
    
    // MARK: - Properties
    var textFont = UIFont(name: "Helvetica Neue", size: 16.0)
    
    override func draw(_ rect: CGRect) {
        
        self.layer.masksToBounds = false
        self.tintColor = tintCol
        self.textColor = fontCol
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor(netHex: 0x999999).cgColor
        self.layer.cornerRadius = 8.0
        
        if let phText = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(string: phText, attributes: [NSAttributedStringKey.foregroundColor: UIColor(netHex: 0xB3B3B3)])
        }
        
        if let fnt = textFont {
            self.font = fnt
        } else {
            self.font = UIFont(name: "Helvetica Neue", size: 17.0)
        }
    }
    
    // Placeholder text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20, dy: 0)
    }
    
    // Editable text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 20, dy: 0)
    }
    
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        
        if let image = leftImage {
            
            leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
        
    }
}
