//
//  TCScreenShotTools.swift
//  TCScreenShotTools
//
//
//  Created by 谈超 on 2017/5/15.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
public protocol TCScreenShotToolsDelegate {
    func screenShotTools(_tools:TCScreenShotTools, didClickShareBtn withShareType: TrickyShareType, withIcon: UIImage ,in shareView: TrickyShareView)
}
public class TCScreenShotTools: NSObject {
    public var delegate:TCScreenShotToolsDelegate?
    
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
extension TCScreenShotTools{
    func shareView(_ shareView: TrickyShareView, didClickShareBtn withShareType: TrickyShareType, withIcon: UIImage) {
        delegate?.screenShotTools(_tools: self, didClickShareBtn: withShareType, withIcon: withIcon, in: shareView)
    }
}
extension TCScreenShotToolsDelegate{
    public func screenShotTools(_tools:TCScreenShotTools, didClickShareBtn withShareType: TrickyShareType, withIcon: UIImage ,in shareView: TrickyShareView){}

}
