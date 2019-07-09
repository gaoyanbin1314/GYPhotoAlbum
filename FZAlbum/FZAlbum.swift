//
//  FZAlbum.swift
//  FZAlbum
//
//  Created by 李雷川 on 2018/12/26.
//  Copyright © 2018年 李雷川. All rights reserved.
//

import UIKit
import Photos

let isiPhoneX =  UIScreen.main.bounds.height == 812 ? true : false
let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
let kNavBarHeight :CGFloat = 44.0

public class FZAlbum: UINavigationController {
    
    ///
    /// - Parameters:
    ///   - maxImagesCount: 本次可选相片的最大数量
    ///   - delegate: FZAlbumViewControllerDelegate 代理
    convenience public init(maxImagesCount: Int, delegate: FZAlbumViewControllerDelegate?){
        self.init()
        let vc = FZAlbumViewController.init(maxImagesCount: maxImagesCount, delegate: delegate)
        self.pushViewController(vc, animated: false)
    }
    
    // 返回时 动画设置
    public var dismissAnimate = true
    
    /// 权限判断
    typealias CheckPhotoAuthBlock = (_ result: Bool) -> Void
    /// 获取相册模块
    typealias GetModulesDataBlock = (_ result: [PHAssetCollection]) -> Void
    /// 获取模块的全部数据
    typealias GetPhotoDataBlock = (_ result: [FZAlbumModel]) -> Void
    
    /// 获取权限
    class func checkPhotoAuth(checkPhotoAuthBlock: @escaping CheckPhotoAuthBlock) -> Bool {
        
        // 相册权限
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == PHAuthorizationStatus.notDetermined {
            
            PHPhotoLibrary.requestAuthorization({ (status:PHAuthorizationStatus) in
                
                if(status == PHAuthorizationStatus.authorized) {
                    checkPhotoAuthBlock(true)
                }else {
                    checkPhotoAuthBlock(false)
                }
            })
        }else if(authStatus == PHAuthorizationStatus.authorized) {
            return true
        }
        return false
    }
    
    
    /// 添加相册模块数据  Modules
   class func getModulesData(getModulesBlock: @escaping GetModulesDataBlock) {
    
        var dataArray = [PHAssetCollection]()
        DispatchQueue.global().async {
    
            let smartAssetCollections = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
            smartAssetCollections.enumerateObjects({ (assetCollection, _, _) in
                
                let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
                if assets.count != 0 {
                    dataArray.append(assetCollection)
                }
            })
            
            let userAssetCollections = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
            userAssetCollections.enumerateObjects({ (assetCollection, _, _) in
                
                let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
                if assets.count != 0 {
                    dataArray.append(assetCollection)
                }
            })
            
            getModulesBlock(dataArray)
        }
    }
    
    /// 获取各个子模块的全部数据
    class func getPhotosData(assetCollection :PHAssetCollection ,getPhotoDataBlock: @escaping GetPhotoDataBlock) {
        
        var photos = [FZAlbumModel]()
        DispatchQueue.global().async {

            let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
            assets.enumerateObjects({ (asset: PHAsset, _, _) in
                
                if asset.mediaType == PHAssetMediaType.image {   
                    let assetModel = FZAlbumModel()
                    assetModel.asset = asset
                    photos.append(assetModel)
                }
            })
             getPhotoDataBlock(photos)
        }
    }
    
    class func fzImageNamed(imageName:String)->String{
        
        let framework = "FZAlbum.framework"
        let bundleName = "FZAlbum.bundle"
        let path = "Frameworks/\(framework)/\(bundleName)/\(imageName)"
        return path
    }
    
}
