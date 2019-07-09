//
//  ViewController.swift
//  FZAlbumDemo
//
//  Created by 李雷川 on 2018/12/26.
//  Copyright © 2018年 李雷川. All rights reserved.
//

import UIKit
import FZAlbum
import Photos
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }

    @IBAction func tapChoosePhoto(_ sender: Any) {
        let vc = FZAlbum.init(maxImagesCount: 9, delegate: self)
        vc.dismissAnimate = false
        self.present(vc, animated: true, completion: nil)
    }
}

extension UIViewController :FZAlbumViewControllerDelegate{
    
    public func didFinishedSelect(_ selectPhotos: [FZAlbumModel]) {
        
        for item in selectPhotos {
            print(item.asset)
        }
    }
    
    public func dismissEvent() {
        print("dismiss")
    }
    
}

