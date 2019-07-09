//
//  Functions.swift
//  Calligraphy
//
//  Created by 李雷川 on 2016/10/31.
//  Copyright © 2016年 李雷川. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

//根据文字内容计算显示高度
public func labelHeightWith(text:String,width:CGFloat,font:UIFont,constrainHeight:CGFloat = 36)->CGFloat{
    let size =  CGSize(width: width, height: constrainHeight)
    let rect = text.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:font], context: nil)
    return rect.height
}

//根据文字内容计算显示宽度
public func labelWidthWith(text:String,height:CGFloat,font:UIFont,constrainWidth:CGFloat = 36)->CGFloat{
    let size =  CGSize(width: constrainWidth, height: height)
    let rect = text.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:font], context: nil)
    return rect.width
}


//计算文件夹大小
public func folderSize(path:String) -> String{
    var fileSize = "0"
    if let files =  FileManager.default.subpaths(atPath: path){
        var size:UInt64 = 0
        for file in files {
            let fullFilePath = path + "/\(file)"
            do{
                if let attr: NSDictionary = try FileManager.default.attributesOfItem(atPath: fullFilePath) as NSDictionary? {
                    size = size + attr.fileSize()
                }
            }catch{
                
            }
            
        }
        fileSize = size.toFileSizeString()
    }
    
    return fileSize
}


//创建文件夹
public func createFolder(_ path:String) -> Bool{
    if(FileManager.default.fileExists(atPath: path, isDirectory: nil) == false){
        do{
            try   FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
        }catch let error as NSError{
            debugPrint(error)
            return false
        }
    }
    return true
}

//移除文件夹
public func removeFile(_ path:String) -> Bool{
    if(FileManager.default.fileExists(atPath: path, isDirectory: nil) == false){
        do{
            try   FileManager.default.removeItem(atPath: path)
        }catch let error as NSError{
            debugPrint(error)
            return false
        }
    }
    return true
}


//MARK 警告提示
public func showAlertController(title:String,message:String?,confirm:String = "确定" ,parentController:UIViewController,cofirmClosure:(()->Void)?){
    
    let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertViewController.addAction(UIAlertAction(title: confirm, style:.cancel, handler: { (UIAlertAction) -> Void in
        if let doClosure = cofirmClosure{
            doClosure()
        }
    }))
    parentController.present(alertViewController, animated: true, completion: nil)
}



public func showAlertController(title:String,message:String?,parentController:UIViewController){
    
    let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertViewController.addAction(UIAlertAction(title: "确定", style:.cancel, handler: { (UIAlertAction) -> Void in
    }))
    parentController.present(alertViewController, animated: true, completion: nil)
}


public func showAlertController(title:String,message:String?,confirm:String = "确定",cancel:String = "取消",parentController:UIViewController,cofirmClosure:@escaping ()->Void,cancelClosure:@escaping ()->Void){
    
    let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertViewController.addAction(UIAlertAction(title: confirm, style:.default, handler: { (UIAlertAction) -> Void in
        cofirmClosure()
    }))
    
    alertViewController.addAction(UIAlertAction(title: cancel, style:.cancel, handler: { (UIAlertAction) -> Void in
        cancelClosure()
    }))
    parentController.present(alertViewController, animated: true, completion: nil)
}


public func networkIsReachiable()->Bool{
    if(NetworkManager.sharedInstance.isReachable() == false){
        let notConnectNetwork =  NSLocalizedString("notConnectNetwork", comment: "")
        FZSFHUD.prompt(message: notConnectNetwork)
    }
    return NetworkManager.sharedInstance.isReachable()
}

public func fzImageNamed(framework:String,bundle:String,imageName:String)->String{
  
    let path = "Frameworks/\(framework)/\(bundle)/\(imageName)"
    return path
}

// 相机权限
public func isRightCamera() -> Bool {
    let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    return authStatus != .restricted && authStatus != .denied
}

// 相册权限
public func isRightPhoto() -> Bool {
    let authStatus = PHPhotoLibrary.authorizationStatus()
    return authStatus != .restricted && authStatus != .denied
}

//是否是刘海屏
public func iPhoneNotchScreen()->Bool{
    var iPhoneNotchDirectionSafeAreaInsets:CGFloat = 0
    if #available(iOS 11.0, *){
        if let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets{
            switch UIApplication.shared.statusBarOrientation{
            case .portrait:
                iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.top
            case .portraitUpsideDown:
                iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.bottom
            case .landscapeLeft:
                iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.left
            case .landscapeRight:
                iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.right
            case .unknown:
                iPhoneNotchDirectionSafeAreaInsets = safeAreaInsets.top
            }
        }
    }else{
        return false
    }
    return iPhoneNotchDirectionSafeAreaInsets > 20
}
