//
//  FZAlumbModulesCell.swift
//  FZAlbum
//
//  Created by 王欣 on 2019/1/8.
//  Copyright © 2019年 李雷川. All rights reserved.
//

import UIKit
import SnapKit

class FZAlbumModulesCell: UITableViewCell {

    
    lazy var leftImageView :UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor(hexString: "#D9D9D9")?.cgColor
        return imageView
    }()
    
    lazy var nameLabel :UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#4A4A4A")
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var numberLabel :UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#9B9B9B")
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
        leftImageView.contentMode = .scaleAspectFit
        addSubview(leftImageView)
        addSubview(nameLabel)
        addSubview(numberLabel)
        leftImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.size.equalTo(63)
            make.centerY.equalTo(self)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(19)
            make.left.equalTo(leftImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(20)
        }
        numberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.left.right.equalTo(nameLabel)
            make.height.equalTo(20)
        }
    }
}
