//
//  CustomImageView.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/5/8.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    var urlImageString: String?
    
    public func imageFromServerURL(urlString: String) {
        
        urlImageString = urlString
        
        //get the image from the cache first to avoid redundant loading of uiimage
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                let imageToCache = UIImage(data: data!)
                
                //原本image load太慢，image不會load到相對應的地方 -> 把extension改成subclass，檢查若有對應到再放
                if self.urlImageString == urlString{
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
            })
            
        }).resume()
    }
}

