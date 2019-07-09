//
//  Device.swift
//  Calligraphy
//
//  Created by 李雷川 on 2017/5/22.
//  Copyright © 2017年 李雷川. All rights reserved.
//

import UIKit

extension UIDevice {
    
    public func appVersion()->String{
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        return "\(version).\(build)"
    }
    
    public func deviceID()->String{
        return FZOpenUDID.value()
    }

}
