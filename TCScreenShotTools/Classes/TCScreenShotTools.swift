//
//  TCScreenShotTools.swift
//  TCScreenShotTools
//
//
//  Created by 谈超 on 2017/5/15.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
public class TCScreenShotTools: NSObject {
    var bgWindows : [UIWindow] = []
//    public var handle:ShareBtnClickHandle?
    public var handle : ((TrickyShareView, _ didClickShareBtn: TrickyShareType, _ withIcon: UIImage) -> () )?
    /// 全局唯一实例
    public static let shared: TCScreenShotTools = {
        let instance = TCScreenShotTools()
        
        return instance
    }()
    
    func screenShot() {
        TrickyTipsView.shared.showTips()
    }
    /// 监听截图事件开关
    public var enable = false {
        didSet {
            if enable == true &&
                oldValue == false {
                //添加监听事件
                NotificationCenter.default.addObserver(self, selector: #selector(screenShot), name: NSNotification.Name.UIApplicationUserDidTakeScreenshot, object: nil)
            } else if enable == false {
                NotificationCenter.default.removeObserver(self)
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension TCScreenShotTools: TrickyShareViewDelegate{
    public func shareView(_ shareView: TrickyShareView, didClickShareBtn withShareType: TrickyShareType, withIcon: UIImage) {
        handle?(shareView,withShareType,withIcon)
//        self.handle?(withShareType,withIcon)
    }
}
