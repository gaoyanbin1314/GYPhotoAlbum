//
//  UITextField+Extension.swift
//  Calligraphy
//
//  Created by 汤 on 2016/12/7.
//  Copyright © 2016年 李雷川. All rights reserved.
//

import UIKit

extension UITextField {
    
    //生成一个圆角的输入框
   public static func normalTextFiled() -> UITextField {
        let textFiled = UITextField()
        textFiled.font = AppFonts.large
        textFiled.clearButtonMode = UITextFieldViewMode.always
        textFiled.borderStyle = .roundedRect
        textFiled.layer.cornerRadius = 4
        textFiled.layer.borderColor = AppColors.line.cgColor
        
        let clearButton = textFiled.value(forKeyPath:"_clearButton")
        (clearButton as! UIButton).setImage(UIImage(named: "close"), for: .normal)
        return textFiled
    }
    
    //生成一个无边框的输入框
    public static func noBorderTextFiled() -> UITextField {
        let textFiled = UITextField()
        textFiled.font = AppFonts.large
        textFiled.backgroundColor = UIColor.white
        textFiled.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        //设置显示模式为永远显示(默认不显示)
        textFiled.leftViewMode = UITextFieldViewMode.always
        textFiled.clearButtonMode = UITextFieldViewMode.always
        textFiled.borderStyle = .none
        let clearButton = textFiled.value(forKeyPath:"_clearButton")
        (clearButton as! UIButton).setImage(UIImage(named: "close"), for: .normal)
        return textFiled
    }
}
