//
//  TCScreenShotTools.swift
//  TCScreenShotTools
//
//
//  Created by 谈超 on 2017/5/15.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
public struct TCPlatform {
    public static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
public protocol TCScreenShotToolsDelegate {
    
    /// Called after the user clicked the shareButton.
    ///
    /// - Parameters:
    ///   - _tools: _tools
    ///   - withShareType: shareType
    ///   - withIcon: icon
    ///   - shareView: shareView
    func screenShotTools(_tools:TCScreenShotTools, didClickShareBtn withShareType: TrickyShareType, withIcon: UIImage ,in shareView: TrickyShareView)
}
public class TCScreenShotTools: NSObject {
    
    public var delegate:TCScreenShotToolsDelegate?
    
    /// 全局唯一实例
    public static let shared = TCScreenShotTools()
    
   
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

// MARK: - 响应事件
extension TCScreenShotTools{
    func shareView(_ shareView: TrickyShareView, didClickShareBtn withShareType: TrickyShareType, withIcon: UIImage) {
        delegate?.screenShotTools(_tools: self, didClickShareBtn: withShareType, withIcon: withIcon, in: shareView)
    }
    func simulatorScreenSnapshot(){
        guard let window = UIApplication.shared.keyWindow else { return }
        // 用下面这行而不是UIGraphicsBeginImageContext()，因为前者支持Retina
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, 0.0)
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image!, self, nil, nil)
    }
    func tipsShow(title:String?,message:String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    func screenShot() {
        if TCPlatform.isSimulator {
            tipsShow(title: "模拟器📱", message: "当前设备为模拟器～")
            simulatorScreenSnapshot()
        }
        TrickyTipsView.shared.showTips()
    }
}
extension TCScreenShotToolsDelegate{
    public func screenShotTools(_tools:TCScreenShotTools, didClickShareBtn withShareType: TrickyShareType, withIcon: UIImage ,in shareView: TrickyShareView){}

}
