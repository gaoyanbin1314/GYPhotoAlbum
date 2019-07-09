//
//  String+Extension.swift
//  Calligraphy
//
//  Created by 李雷川 on 2016/11/7.
//  Copyright © 2016年 李雷川. All rights reserved.
//

import Foundation
import UIKit
extension String {
    public static func utf8StringFromData(_ data: Data) -> String {
        return String(describing: NSString(data: data, encoding: String.Encoding.utf8.rawValue))
    }
    
    public func textSizeWithFont(font:UIFont)->CGSize{
        return  (self as NSString).size(withAttributes: [NSAttributedStringKey.font:font])
    }
    
    public func urlEncode()->String{
        let urlEncodeString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return urlEncodeString!
    }
    public func toRegx()->String{
        var regxContent=NSString(string:self)
        regxContent = regxContent.replacingOccurrences(of: "%", with: "%25") as NSString
        regxContent = regxContent.replacingOccurrences(of: "+", with: "%2B") as NSString
        regxContent = regxContent.replacingOccurrences(of: " ", with: "%20") as NSString
        regxContent = regxContent.replacingOccurrences(of: "/", with: "%2F") as NSString
        regxContent = regxContent.replacingOccurrences(of: "?", with: "%3F") as NSString
        regxContent = regxContent.replacingOccurrences(of: "#", with: "%23") as NSString
        regxContent = regxContent.replacingOccurrences(of: "=", with: "%3D") as NSString
        return regxContent as String
    }
    
    public func isUrl()->Bool{
        if(self.hasPrefix("https://") || self.hasPrefix("http://")){
            return true
        }
        return false
    }
    // 转基本类型
    public func toInt() -> Int{
        return NSString(string: self).integerValue
    }
    
    public func toFloat() -> Float{
        return NSString(string: self).floatValue
    }
    
    public func toDouble() -> Double{
        return NSString(string: self).doubleValue
    }
    
    public func toCGFloat() -> CGFloat{
        return CGFloat(NSString(string: self).integerValue)
    }
    public func toDateWithFormat(_ format: String) -> Date{
        let df = DateFormatter()
        df.dateFormat = format
        return df.date(from: self)!
    }
    
    public var length: Int{
        return  self.count
    }

    public func stringToInt() ->String{
        return String(lroundf(self.toFloat()))
    }
    public func toUTF8String() -> UnsafePointer<Int8> {
        return (self as NSString).utf8String!
    }
    
    public func toUnicode()->String{
        let length = self.length
        let s = NSMutableString(capacity: 0)
        let string = self as NSString
        for i in 0..<length {
            let  _char = string.character(at: i)
            //判断是否为英文和数字
            if (_char <= 9 && _char >= 0) {
                s.appendFormat("%@",string.substring(with: NSRange(location: i,length: 1)))
            }else if(_char >= 97 && _char <= 122)
            {
                s.appendFormat("%@",string.substring(with: NSRange(location: i,length: 1)))
            }else if(_char >= 65 && _char <= 90)
            {
                s.appendFormat("%@",string.substring(with: NSRange(location: i,length: 1)))
            }else
            {
                s.appendFormat("%x",_char)
            }
            
        }
        return s as String;
    }
    
}
