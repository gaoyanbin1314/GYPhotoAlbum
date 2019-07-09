//
//  NoNetworkView.swift
//  CalligraphyUniversal
//
//  Created by 李雷川 on 2017/8/22.
//  Copyright © 2017年 李雷川. All rights reserved.
//

import UIKit

class FZSFPlaceholderView: UIView {
    fileprivate let infoLabel = UILabel.createLabel(textColor: AppColors.state, font: AppFonts.large, defaultText: "网络连接异常，点击屏幕重试")
    fileprivate let logoImageView = UIImageView.init(image: UIImage.init(named: "no_network"))
    
    open var refreshClosure:(()->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initUI(){
        addSubview(infoLabel)
        addSubview(logoImageView)

        logoImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        infoLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(logoImageView.snp.bottom).offset(12)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:Any in touches{
            if let t = touch as? UITouch{
                if(t.tapCount == 1){
                    if let doClosure = refreshClosure{
                        doClosure()
                    }
                }
            }
        }
    }

}
