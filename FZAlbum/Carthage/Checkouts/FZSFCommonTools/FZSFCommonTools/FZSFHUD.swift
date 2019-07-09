//
//  FZSFTools.swift
//  CalligraphyUniversal
//
//  Created by 李雷川 on 2017/12/26.
//  Copyright © 2017年 李雷川. All rights reserved.
//

import UIKit
public let defaultDelay:TimeInterval = 2
public let  commonframework = "FZSFCommonTools.framework"
public let  commonframeworkbundleName = "FZSFCommonTools.bundle"

public func fzsfImageNamed(imageName:String)->String{
    return fzImageNamed(framework: commonframework, bundle: commonframeworkbundleName, imageName: imageName)
}


public class FZSFHUD: NSObject {
    public static  func defaultHUD(view:UIView)->FZProgressHUD{
        let hud = FZProgressHUD.showAdded(to: view, animated: true)
        hud.bezelView.color = UIColor.black.withAlphaComponent(0.6)
        hud.bezelView.style = .solidColor
        hud.contentColor = AppColors.foreground
        hud.label.font = AppFonts.normal
        hud.label.textColor = AppColors.state
        return hud
    }
    
    // 显示提示信息
    public static func show(message:String,detailMesssage:String = "",delay:TimeInterval = 0,view:UIView? = UIApplication.shared.keyWindow)->FZProgressHUD?{
        
        guard view != nil else {
            return nil
        }
        let hud = defaultHUD(view: view!)
        hud.label.text = message
        hud.detailsLabel.text = detailMesssage
        if(delay > 0){
            DispatchQueue.main.async {
                hud.hide(animated: true, afterDelay: delay)
            }
            return nil
        }
        return hud
        
    }
    
    public static func prompt(message:String,delay:TimeInterval = defaultDelay){
        let view  = UIApplication.shared.keyWindow
        guard view != nil else {
            return
        }
        let hud = defaultHUD(view: view!)
        hud.mode = .text
        hud.label.text = message
        hud.label.numberOfLines = 0
        DispatchQueue.main.async {
            hud.hide(animated: true, afterDelay: delay)
        }
    }
    
    
    public static func successPrompt(message:String,delay:TimeInterval = defaultDelay,completionBlock:(()->Void)?){
        let view  = UIApplication.shared.keyWindow
        guard view != nil else {
            return
        }
        let hud = defaultHUD(view: view!)
        hud.mode = .customView
        let image = UIImage(named: fzsfImageNamed(imageName: "prompt_success"))
        hud.customView = UIImageView.init(image: image)
        hud.label.text = message
        hud.hide(animated: true, afterDelay: delay)
        hud.completionBlock = completionBlock
    }
    
    public static func faildPrompt(message:String,delay:TimeInterval = defaultDelay){
        
        let view  = UIApplication.shared.keyWindow
        guard view != nil else {
            return
        }
        let hud = defaultHUD(view: view!)
        hud.mode = .customView
        let image = UIImage(named: fzsfImageNamed(imageName: "prompt_error"))
        hud.customView = UIImageView.init(image: image)
        hud.label.text = message
        DispatchQueue.main.async {
            hud.hide(animated: true, afterDelay: delay)
        }
        
    }
}

