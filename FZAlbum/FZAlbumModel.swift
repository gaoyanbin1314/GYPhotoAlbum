
//
//  FZAlbumModel.swift
//  FZAlbum
//
//  Created by 王欣 on 2019/1/8.
//  Copyright © 2019年 李雷川. All rights reserved.
//

import UIKit
import Photos

// 返回的相片数据
public class FZAlbumModel: NSObject {
    /// 资源
   public var asset: PHAsset!
    /// 缩略图
   public var thumbnailImage: UIImage?
    /// 是否选择
    var isSelected: Bool = false
    /// 第几个被选择的
    var selectedSerialNumber: Int = 0
    

}
