//
//  ViewController.swift
//  FZSFCommonToolsDemo
//
//  Created by 李雷川 on 2018/4/18.
//  Copyright © 2018年 李雷川. All rights reserved.
//

import UIKit
import FZSFCommonTools
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        view.backgroundColor = AppColors.highlight
       
        
          let label = UILabel.createLabel(textColor: AppColors.main, font: AppFonts.veryLarge, defaultText: "")
        let contentView = UIView()
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor.red.cgColor
        contentView.backgroundColor = UIColor.white
        contentView.frame = CGRect.init(x: 100, y: 100, width: 200, height: 44)
        view.addSubview(contentView)
        contentView.corner(radius: 4, shadowOffSet: CGSize.init(width: 2, height: 2), shadowOpacity: 1.0)
        if(isRightCamera()){
            debugPrint("true")
        }
        else{
            debugPrint(false)
        }
      
    }

    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

