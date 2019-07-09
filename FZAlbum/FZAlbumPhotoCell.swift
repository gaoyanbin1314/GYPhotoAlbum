//
//  FZAlumbPhotoCell.swift
//  FZAlbum
//
//  Created by 王欣 on 2019/1/9.
//  Copyright © 2019年 李雷川. All rights reserved.
//

import UIKit


protocol FZAlumbPhotoCellDelegate: NSObjectProtocol {
    
    func epPhotoTagBtnHandle(_ assetModel:FZAlbumModel)
    func epImageViewHandle(_ assetModel:FZAlbumModel)
    
}

class FZAlbumPhotoCell: UICollectionViewCell {

   
    weak var delegate: FZAlumbPhotoCellDelegate?
    
    var assetModel: FZAlbumModel?
    
    lazy var photoImageView :UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(imageViewHandle))
        imageView.addGestureRecognizer(tap)
        
        return imageView
    }()
    
    lazy var photoTagBtn :UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(hexString: "#000000", alpha: 0.1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(photoTagBtnHandle), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var photoMaskView :UIImageView = {
        let view = UIImageView.init()
        view.backgroundColor = UIColor.white
        view.alpha = 0.4
        return view
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
        addSubview(photoTagBtn)
        addSubview(photoMaskView)
        
        photoImageView.snp.makeConstraints { (make) in
             make.edges.equalToSuperview()
        }
        
        photoTagBtn.snp.makeConstraints { (make) in
            make.top.equalTo(6)
            make.right.equalTo(photoImageView).offset(-6)
            make.size.equalTo(16)
        }
        photoMaskView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
  
    func updateMaskView(_ isHidden :Bool,_ assetModel: FZAlbumModel) {
        
        if assetModel.isSelected {
             photoMaskView.isHidden = true
        } else {
            photoMaskView.isHidden = isHidden
        }
    }
    
    func updateAssetModel(_ assetModel: FZAlbumModel,isOneChoose: Bool) {
        
        self.assetModel = assetModel
        photoImageView.image = assetModel.thumbnailImage
        
        if assetModel.isSelected == true {
            photoTagBtn.backgroundColor = UIColor(hexString: "#B4272D")
            photoTagBtn.setTitle(String(assetModel.selectedSerialNumber), for: UIControl.State.normal)
        }else {
            photoTagBtn.backgroundColor = UIColor.clear
            photoTagBtn.backgroundColor = UIColor(hexString: "#000000", alpha: 0.1)
            photoTagBtn.setTitle("", for: UIControl.State.normal)
        }
    }
    
    @objc func photoTagBtnHandle(_ sender: Any) {
        if let assetModel = self.assetModel {
            if photoMaskView.isHidden {
                delegate?.epPhotoTagBtnHandle(assetModel)
            }
        }
    }
    
    @objc func imageViewHandle() {
        if let assetModel = self.assetModel {
            if photoMaskView.isHidden {
                delegate?.epImageViewHandle(assetModel)
            }
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let view = super.hitTest(point, with: event)
        let testRect :CGRect = CGRect.init(x: photoTagBtn.frame.origin.x - 24,
                                           y: photoTagBtn.frame.origin.y - 6,
                                           width: photoTagBtn.frame.size.width + 30,
                                           height: photoTagBtn.frame.size.height + 30)
        if testRect.contains(point) && photoMaskView.isHidden{
            return photoTagBtn
        }
        
        return view
    }
}
