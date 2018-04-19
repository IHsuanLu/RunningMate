//
//  DateTextFieldLong.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/8.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

@IBDesignable
class DateTextFieldLong: UITextField{
    
    // Placeholder text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    // Editable text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    // Provides left padding for images
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        _ = super.rightViewRect(forBounds: bounds)
        
        return UIEdgeInsetsInsetRect(bounds,
                                     UIEdgeInsetsMake(0, 81, 0, 0))
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    
    @IBInspectable var color: UIColor = UIColor(netHex: 0x47484C) {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        
        if let image = rightImage {
            
            rightViewMode = UITextFieldViewMode.always
            
            let imageView = UIImageView(frame: CGRect(x: self.frame.size.width - 15, y: 0, width: 10, height: 10))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            rightView = imageView
        } else {
            rightViewMode = UITextFieldViewMode.never
            rightView = nil
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 8.0
        self.layer.borderColor = UIColor(netHex: 0x999999).cgColor
    }
}

