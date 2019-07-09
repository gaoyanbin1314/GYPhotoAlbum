//
//  FZSFCommonDef.swift
//  FZSFCommonTools
//
//  Created by 李雷川 on 2018/4/18.
//  Copyright © 2018年 李雷川. All rights reserved.
//

import UIKit

public let isiPhoneX =  iPhoneNotchScreen()
public let topMargin = isiPhoneX ? 20 : 0
public let bottomMargin = isiPhoneX ? 34 : 0
public var productType = ProductType.release
public let isiPad = UIScreen.main.bounds.width == 768 ? true : false

public var kDocumentPath: String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory as String
}

public var kLibraryPath: String {
    let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
    let libraryDirectory = paths[0]
    return libraryDirectory as String
}

public var kCachePath: String {
    let cachePaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,
                                                         FileManager.SearchPathDomainMask.userDomainMask, true)
    let cachePath = cachePaths[0]
    return cachePath as String
}

public var kAppPath: String {
    let paths = NSSearchPathForDirectoriesInDomains(.applicationDirectory, .userDomainMask, true)
    let applicationDirectory = paths[0]
    return applicationDirectory as String
}

public var kDownloadFolder: String {
    let downloadFolder =  kLibraryPath + "/download"
    if createFolder(downloadFolder){
        return downloadFolder
    }
    return ""
    
}

public var kResumeFolder: String {
    let downloadFolder =  kLibraryPath + "/resume"
    if createFolder(downloadFolder){
        return downloadFolder
    }
    return ""
    
}

public let alertTitle = (
    loginFailed:"登录失败",
    registFailed:"注册失败"
)

public let errorMessage = (
    noContent:"没有内容",
    timeout:"请求超时,请稍候再试",
    unknown:"未知设备",
    modify:"修改失败",
    connect:"连接失败",
    unknowError:"未知错误",
    loginFaild:"登录失败"
)

public let hudMessage = (
    loging:"正在登录",
    success:"提交成功",
    loading:"正在加载",
    submiting:"正在提交",
    uploading:"上传中",
    connecting:"正在连接",
    scoring:"正在测评",
    unbinding:"正在解绑",
    sending:"正在发送"
)


// 颜色
public let AppColors = (
    tiny:UIColor(hexString: "#B4272D")!,
    background:UIColor(hexString: "#F2F2F2")!,
    contentBackground:UIColor(hexString: "#F6F6F6")!,
    highlight:UIColor(hexString: "#B4272D")!,
    main:UIColor(hexString: "#333333")!,
    info:UIColor(hexString: "#666666")!,
    prompt:UIColor(hexString: "#999999")!,
    foreground:UIColor(hexString: "#FFFFFF")!,
    line:UIColor(hexString: "#E8E8E8")!,
    state:UIColor(hexString: "#D8D8D8")!,
    tap:UIColor(hexString: "#3773A7")!,
    bar:UIColor(hexString: "#F8F8F8")!,
    disable:UIColor(hexString: "#EAEAEA")!,
    comment:UIColor(hexString: "#2783B4")!,
    shadow:UIColor(hexString: "#555555")!,
    important:UIColor(hexString: "#4A4A4A")!,
    action:UIColor(hexString: "#4A90E2")!
    
)
// 字体
public let AppFonts = (
    maxLarge:UIFont.systemFont(ofSize: 36),
    verySuperLarge:UIFont.systemFont(ofSize: 24),
    superLarge:UIFont.systemFont(ofSize: 20),
    boldVeryLarge:UIFont.boldSystemFont(ofSize: 18),
    veryLarge:UIFont.systemFont(ofSize: 18),
    littleLarge:UIFont.systemFont(ofSize: 16),
    boldLittleLarge:UIFont.boldSystemFont(ofSize: 16),
    large:UIFont.systemFont(ofSize: 15),
    normal:UIFont.systemFont(ofSize: 14),
    boldNormal:UIFont.boldSystemFont(ofSize: 14),
    littleSmall:UIFont.systemFont(ofSize: 13),
    small:UIFont.systemFont(ofSize: 12),
    verySmall:UIFont.systemFont(ofSize: 10),
    minSmall:UIFont.systemFont(ofSize: 9),
    veryLargeNumber:UIFont.init(name: "DINAlternate-Bold", size: 36)!,
    largeBoldNumber:UIFont.init(name: "DINAlternate-Bold", size: 24)!,
    normalBoldNumber:UIFont.init(name: "DINAlternate-Bold", size: 21)!,
    smallBoldNumber:UIFont.init(name: "DINAlternate-Bold", size: 18)!,
    littersmallBoldNumber:UIFont.init(name: "DINAlternate-Bold", size: 14)!,
    verySmallBoldNumber:UIFont.init(name: "DINAlternate-Bold", size: 10)!
)

//外边距
public let AppMargin = (
    leadding:CGFloat(12.0),
    trailing:CGFloat(12.0),
    topMargin:CGFloat(12.0),
    bottomMargin:CGFloat(12.0),
    top:CGFloat(8.0),
    bottom:CGFloat(8.0),
    left:CGFloat(12.0),
    right:CGFloat(12.0)
)

public let AppUserDefault = (
    userType : "userType",
    unionID : "unionID",
    openID : "openID",
    lastUserID : "lastUserID",
    lastLoginTime : "lastLoginTime",
    exercise: "exericse",
    hypenDevice:"hypenDevice",
    lastVerifycodeTime:"lastVerifycodeTime",
    squarePercent:"squarePercent",
    serverType:"serverType"
)


public let AppNotification = (
    menu : "kSwitchMenuNotification",
    startStudy:"kStartStudyNotification",
    bindPhone:"kBindPhoneNotification",
    refreshUserInfo:"kRefreshUserInfo"
)


public enum  ServerType:String{
    case release =   "线上"
    case preRelease =  "预发布版"
    case debug  =   "内测版"
    case system  =   "系统"
    case dev  =     "开发测试"
    public var server:String{
        switch self {
        case .release:
            return "api.fangzhengshufa.com"
        case .preRelease:
            return "pre.fangzhengshufa.com"
        case .system:
            return "systest.fangzhengshufa.com"
        case .debug:
            return "commtest.fangzhengshufa.com"
        case .dev:
            return "commdev.fangzhengshufa.com"
        }
    }
    public var url:String{
        return "http://" + self.server  + "/index.php"
    }
}


public enum ProductType:Int{
    case release = 0
    case debug = 1
    public var serverType:ServerType{
        switch self {
        case .release:
            return ServerType.release
        case .debug:
            let userDefault = UserDefaults.standard
            if let rawValue = userDefault.value(forKeyPath: AppUserDefault.serverType) as? String{
                if let serverType = ServerType(rawValue: rawValue){
                    return serverType
                }
                return ServerType.debug
            }
            else{
                userDefault.setValue(ServerType.preRelease.rawValue, forKey: AppUserDefault.serverType)
                return ServerType.preRelease
            }
        }
    }
    public var hardBaseUrl:String{
        switch self.serverType {
        case .release:
            return "http://hardeval.fangzhengshufa.com"
        case .debug,.dev,.system,.preRelease:
            return "http://prehardeval.fangzhengshufa.com"
        }
    }
}


