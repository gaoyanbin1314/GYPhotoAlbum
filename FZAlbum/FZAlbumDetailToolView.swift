//
//  FZAlbumDetailToolView.swift
//  FZAlbum
//
//  Created by 王欣 on 2019/1/11.
//  Copyright © 2019年 李雷川. All rights reserved.
//

import UIKit


protocol FZAlbumDetailToolViewDelegate: NSObjectProtocol {
    
    func goBackEvent(_ button :UIButton)
    func selectBtnEvent(_ button :UIButton)
}

class FZAlbumDetailToolView: UIView {
    
    weak var delegate :FZAlbumDetailToolViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuredUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configuredUI() {
        
        addSubview(leftBtn)
        addSubview(selectedBtn)
        
        leftBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(6)
            make.size.equalTo(34)
        }
        
        selectedBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-6)
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
        }
    }
    
    lazy var leftBtn :UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage.init(named: FZAlbum.fzImageNamed(imageName: "arrow_left")), for: UIControl.State.normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var selectedBtn :UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(selectBtnEvent), for: UIControl.Event.touchUpInside)
        button.backgroundColor = UIColor.green
        return button
    }()
    
    
    @objc func goBack(sender :UIButton) {
        
        delegate?.goBackEvent(sender)
    }
    
    @objc func selectBtnEvent(sender :UIButton) {
        
        delegate?.selectBtnEvent(sender)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let view = super.hitTest(point, with: event)
        let testRect :CGRect = CGRect.init(x: UIScreen.main.bounds.size.width - 88,
                                           y: -22,
                                           width: 88,
                                           height: 88)
        
        if testRect.contains(point) {
            return selectedBtn
        }
        return view
    }
}


