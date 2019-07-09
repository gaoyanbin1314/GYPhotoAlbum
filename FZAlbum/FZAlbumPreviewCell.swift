//
//  FZAlbumPreviewCell.swift
//  FZAlbum
//
//  Created by 王欣 on 2019/1/17.
//  Copyright © 2019年 李雷川. All rights reserved.
//

import UIKit

class FZAlbumPreviewCell: UICollectionViewCell {

    
    lazy var photoImageView :UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalToSuperview().offset(-4)
        }
    }
}



