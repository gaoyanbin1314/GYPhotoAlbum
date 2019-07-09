//
//  Int+Extension.swift
//  Calligraphy
//
//  Created by 李雷川 on 2016/11/10.
//  Copyright © 2016年 李雷川. All rights reserved.
//

import UIKit
extension Int{
    public func toPointX() -> Double{
        return round(Double(self))
    }
    public func toPointY()->Double{
        return round (Double(self))
    }
}


extension Int64{
    //将数字字符转换为字符串
    public func toFileSizeString()->String{
        let units = ["MB","GB","TB"]
        var index = 0
        var result = Double(self)/1000000.0
        let unitSize = Double(1000)
        while (result>unitSize) {
            result /= unitSize
            index = index+1
            if(index >= units.count){
                break
            }
        }
        return "\( result.format(".1"))\(units[index])"
    }
    
    public static func toFormatedTimeString(_ seconds: Int) -> String{
        let h = seconds / 3600
        let m = seconds % 3600 / 60
        let s = seconds % 60
        
        return NSString(format: "%02d:%02d:%02d", h,m,s) as String
    }
    
    public func toHourString() -> String{
        let h = Double(self) / 3600.0
        return "\( h.format(".1"))"
    }
    
    
}


extension UInt64{
    //将数字字符转换为字符串
    public func toFileSizeString()->String{
        let units = ["MB","GB","TB"]
        var index = 0
         var result = Double(self)/1000000.0
        let unitSize = Double(1000)
        while (result>unitSize) {
            result /= unitSize
            index = index+1
            if(index >= units.count){
                break
            }
        }
        return "\( result.format(".1"))\(units[index])"
    }
    
}


extension Int64{
    public func convertToDay() -> String {
        
        let date = Date.init(timeIntervalSince1970: TimeInterval(self/1000))
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy/MM/dd H:mm"
        let day =  dateFomatter.string(from: date)
        return day
        
    }
}


extension Double {
    public func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

extension Float {
    public func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
extension Float {
    public func convertToTime() -> String {
        let date = Date.init(timeIntervalSinceReferenceDate: TimeInterval(self))
        let dateFomatter = DateFormatter()
        if(self > 3600){
            dateFomatter.dateFormat = "hh:mm:ss"
        }
        else{
            dateFomatter.dateFormat = "mm:ss"
        }
        let time =  dateFomatter.string(from: date)
        return time
    }
}
