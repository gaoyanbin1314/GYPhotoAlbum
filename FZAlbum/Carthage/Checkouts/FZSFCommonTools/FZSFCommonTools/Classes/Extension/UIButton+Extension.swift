//
//  UIButton+Extension.swift
//  Calligraphy
//
//  Created by 李雷川 on 2016/11/24.
//  Copyright © 2016年 李雷川. All rights reserved.
//

import UIKit


extension UIButton {
   public static func custom(title:String,normalColor:UIColor,highlightedColor:UIColor, radius:CGFloat) -> UIButton{
        let button = UIButton(type: .custom)
        button.layer.masksToBounds = true
        button.setTitle(title, for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(normalColor, size: CGSize(width: 1, height: 1)), for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(highlightedColor, size: CGSize(width: 1, height: 1)), for: .highlighted)
        button.setBackgroundImage(UIImage.imageWithColor(highlightedColor, size: CGSize(width: 1, height: 1)), for: .selected)
        button.layer.cornerRadius = radius
        return button
    }
   public static func custom(title:String,titleColor:UIColor,backgroundColor:UIColor, radius:CGFloat = 0) -> UIButton{
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage.imageWithColor(backgroundColor, size: CGSize(width: 1, height: 1)), for: .normal)
        button.layer.cornerRadius = radius
        button.layer.masksToBounds = true
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        return button
    }

    public static func custom(title:String,titleColor:UIColor,borderColor:UIColor, radius:CGFloat = 4) -> UIButton{
        let button = UIButton(type: .custom)
        button.setTitleColor(titleColor, for: .normal)
        button.setTitle(title, for: .normal)
        button.layer.borderColor = borderColor.cgColor
        button.layer.cornerRadius = radius
        button.layer.borderWidth = 1
        button.layer.masksToBounds = true
        return button
    }
    
    public static func custom(title:String,titleColor:UIColor,font:UIFont = AppFonts.small) -> UIButton{
        let button = UIButton(type: .custom)
        button.setTitleColor(titleColor, for: .normal)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font
        return button
    }
    
    
    //生成红色的通用按钮
    public static func getRedNormalButton() -> UIButton {
        let normalButton = UIButton(type: .custom)
        normalButton.titleLabel?.font = AppFonts.veryLarge
        normalButton.setBackgroundImage(UIImage.imageWithColor(AppColors.highlight, size: CGSize(width: 1, height: 1)),for: UIControlState.normal)
        normalButton.layer.masksToBounds = true
        normalButton.layer.cornerRadius = 4
        
        return normalButton;
    }
    
    //反馈标签按钮
    public static func feedbackButton(title:String) -> UIButton {
        let normalButton = UIButton(type: .custom)
        normalButton.titleLabel?.font = AppFonts.normal
        normalButton.setTitle(title, for: .normal)
        normalButton.layer.masksToBounds = true
        normalButton.layer.cornerRadius = 4
        normalButton.layer.borderWidth = 1
        return normalButton;
    }
    
    
    //生成圆框按钮
   public  static func getRedRectNormalButton() -> UIButton {
        let normalButton = UIButton(type: .custom)
        normalButton.titleLabel?.font = AppFonts.small
        normalButton.setTitleColor(AppColors.highlight, for: UIControlState.normal)
        normalButton.layer.borderWidth = 1
        normalButton.layer.borderColor = AppColors.highlight.cgColor
        normalButton.layer.masksToBounds = true
        normalButton.layer.cornerRadius = 2.5
        
        
        return normalButton;
    }
    
    public func enableState(){
        self.isEnabled = true
        self.layer.borderColor = AppColors.highlight.cgColor
        self.layer.borderWidth = 0
        self.layer.masksToBounds = true
        self.setBackgroundImage(UIImage.imageWithColor(AppColors.highlight, size: CGSize(width: 1, height: 1)), for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    public func disableState(){
        self.isEnabled = false
        self.layer.masksToBounds = true
        self.setTitleColor(AppColors.highlight, for: .normal)
        self.layer.borderColor = AppColors.disable.cgColor
        self.layer.borderWidth = 1
        self.setBackgroundImage(UIImage(), for: .normal)
        self.setTitleColor(AppColors.disable, for: .normal)
    }
    
    public func noBorderEnableState(){
        self.isEnabled = true
        self.setTitleColor(AppColors.foreground, for: .normal)
        self.setBackgroundImage(UIImage.imageWithColor(AppColors.highlight, size: CGSize(width: 1, height: 1)), for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    public func noBorderDisableState(){
        self.isEnabled = false
        self.layer.masksToBounds = true
        self.setTitleColor(UIColor.white, for: .normal)
        self.setBackgroundImage(UIImage.imageWithColor(AppColors.state, size: CGSize(width: 1, height: 1)), for: .normal)
    }
    
    public func feedbackSelectState(){
        self.setTitleColor(AppColors.highlight, for: .normal)
        self.layer.borderColor = AppColors.highlight.cgColor
        self.backgroundColor = UIColor.init(hexString: "B4272D", alpha:0.1)
    }
    
    public func feedbackUnSelectState(){
        self.setTitleColor(AppColors.main, for: .normal)
        self.layer.borderColor = AppColors.info.cgColor
        self.backgroundColor = UIColor.clear
    }
}
