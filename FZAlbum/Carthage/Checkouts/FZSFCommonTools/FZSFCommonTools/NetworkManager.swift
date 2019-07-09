//
//  NetworkManager.swift
//  Calligraphy
//
//  Created by 李雷川 on 2016/12/8.
//  Copyright © 2016年 李雷川. All rights reserved.
//

import UIKit
public class NetworkManager: NSObject {
    public static let sharedInstance = NetworkManager()
    var reach: FZReachability?
    override init() {
        super.init()
        self.startlisening()
    }
    public func startlisening(){
        self.reach = FZReachability.forInternetConnection()
        self.reach!.startNotifier()
    }
    
    public func stopListening(){
        reach?.stopNotifier()
    }
    public func isReachable()->Bool{
        if(reach == nil){
            NetworkManager.sharedInstance.startlisening()
        }
        return (reach!.isReachable())
    }
    
}

