//
//  UIImage+Extension.swift
//  Calligraphy
//
//  Created by 汤 on 2016/11/18.
//  Copyright © 2016年 李雷川. All rights reserved.
//

import UIKit


extension UIImage {
    
    //通过颜色生成一个图片
    public static func imageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    public func resize(size:CGSize) ->UIImage?{
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        self.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let scaleImage =  UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaleImage

    }
}
