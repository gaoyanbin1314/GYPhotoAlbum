//
//  UILabel+Extension.swift
//  Calligraphy
//
//  Created by 李雷川 on 2016/11/9.
//  Copyright © 2016年 李雷川. All rights reserved.
//

import UIKit

 extension UILabel{
    // 样式
   public func style(color: UIColor, font: UIFont, defaultText: String = "", alignment: NSTextAlignment = .left){
        self.textColor = color
        self.text = defaultText
        self.font = font
        self.textAlignment = alignment
    }
    public static func createLabel(textColor color: UIColor?,
	                           font: UIFont,
	                           defaultText: String?) -> UILabel{
        let label = UILabel()
        label.textColor = color
        label.text = defaultText
        label.font = font
        return label
    }
    
    public static func charLabel(text:String)->UILabel{
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = AppFonts.small
        label.textColor = AppColors.highlight
        label.layer.borderColor = AppColors.highlight.cgColor
        label.layer.borderWidth = 0.5
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.init(hexString: "B4272D", alpha: 0.1)
        return label
    }
}
