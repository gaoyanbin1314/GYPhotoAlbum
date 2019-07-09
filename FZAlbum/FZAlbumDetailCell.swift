//
//  FZAlbumDetailCell.swift
//  FZAlbum
//
//  Created by 王欣 on 2019/1/10.
//  Copyright © 2019年 李雷川. All rights reserved.
//

import UIKit

class FZAlbumDetailCell: UICollectionViewCell {
    
    lazy var photoImageView :UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var bottomScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect.zero)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        
        addSubview(bottomScrollView)
        bottomScrollView.addSubview(photoImageView)
        bottomScrollView.delegate = self
        bottomScrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        bottomScrollView.contentSize = self.frame.size
        photoImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalToSuperview().offset(-4)
        }
        photoImageView.contentMode = .scaleAspectFit
    }
    
}

extension FZAlbumDetailCell :UIScrollViewDelegate{
    
    // 设置UIScrollView中要缩放的视图
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    
    // 让UIImageView在UIScrollView缩放后居中显示
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let size = scrollView.bounds.size
        let offsetX = (size.width > scrollView.contentSize.width) ?
            (size.width - scrollView.contentSize.width) * 0.5 : 0.0
        
        let offsetY = (size.height > scrollView.contentSize.height) ?
            (size.height - scrollView.contentSize.height) * 0.5 : 0.0
        photoImageView.center = CGPoint.init(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    
}
