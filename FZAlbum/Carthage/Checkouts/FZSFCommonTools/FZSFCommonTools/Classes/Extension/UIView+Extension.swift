//
//  UIView+Extension.swift
//  CalligraphyUniversal
//
//  Created by 李雷川 on 2016/12/16.
//  Copyright © 2016年 李雷川. All rights reserved.
//

import UIKit

extension UITableViewController{
    override open func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 9.0, *) {
            tableView?.cellLayoutMarginsFollowReadableWidth = false
        }
    }
}


extension UIView{

    public var x:CGFloat{
        return self.frame.origin.x
    }
    
    public var y:CGFloat{
       return self.frame.origin.y
    }
    
    public var width:CGFloat{
        return self.frame.size.width
    }
    
    public var height:CGFloat{
         return self.frame.size.height
    }
    

    public func set(x:CGFloat){
        self.frame.origin.x = x
    }
    
    public func set(y:CGFloat){
        self.frame.origin.y = y
    }

    public func set(whdth:CGFloat){
        self.frame.size.width = whdth
    }
    
    public func set(height:CGFloat){
        self.frame.size.height = height
    }
    
    public func corner(radius:CGFloat = 4,shadowColor:UIColor = AppColors.shadow, shadowOffSet:CGSize =  CGSize.init(width: 0, height: 1),shadowOpacity:Float = 0.5){
        self.layer.cornerRadius = radius
        let beziaPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowPath = beziaPath
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowOffSet
        self.layer.shadowOpacity = shadowOpacity
        
    }
    
    
    public func generateImage()->UIImage?{
        let deviceScale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, deviceScale)
        if let context =  UIGraphicsGetCurrentContext(){
            self.layer.render(in:context)
            let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();
            return screenshotImage
        }
        return nil

    }
    
}
