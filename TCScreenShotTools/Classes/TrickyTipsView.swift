//
//  TrickyTipsView.swift
//  TCScreenShotTools
//
//  Created by 谈超 on 2017/5/15.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import Photos
let tipSViewH :CGFloat  = 70.0

class TrickyTipsView: UIWindow {
    var bgWindows : [UIWindow] = []
    open static let shared: TrickyTipsView = {
        let instance = TrickyTipsView()
        return instance
    }()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: -tipSViewH, width: UIScreen.main.bounds.width, height: tipSViewH))
        buildUI()
    }
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: -tipSViewH, width: UIScreen.main.bounds.width, height: tipSViewH))
    }

    lazy var tipLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "已捕获屏幕截图"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    lazy var bottomTips: UILabel = {
        let lbl = UILabel()
        lbl.text = "点击分享截图给朋友"
        lbl.textColor = tc_Color(hex: "#808080")
        lbl.font = UIFont.systemFont(ofSize: 12)
        return lbl
    }()
    lazy var shareBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = tc_Color(hex: "#ed5c4d")
        btn.setTitle("分享", for: .normal)
        btn.setTitleColor(tc_Color(hex: "#ffffff"), for: .normal)
        btn.addTarget(self, action: #selector(shareButtonClick), for: UIControlEvents.touchUpInside)
        return btn
    }()
    lazy var leftView: UIView = {
        let leftView = UIView()
        leftView.backgroundColor = UIColor.white
        leftView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleSwipeFrom(recognizer:))))
        return leftView
    }()
    lazy var rightView = UIView()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var timer : Timer?
    
}
// MARK:UI搭建
extension TrickyTipsView{
    func buildUI() {
        // UIWindowLevelStatusBar 是当前window遮盖statusBar
        self.windowLevel = UIWindowLevelStatusBar
        self.backgroundColor = UIColor.white
        leftView.addSubview(tipLabel)
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        let tipsLabelConstraints : [NSLayoutConstraint] = [
            tipLabel.bottomAnchor.constraint(equalTo: leftView.centerYAnchor, constant: -10),
            tipLabel.leftAnchor.constraint(equalTo: leftView.leftAnchor, constant: 40)
        ]
        NSLayoutConstraint.activate(tipsLabelConstraints)
        leftView.addSubview(bottomTips)
        bottomTips.translatesAutoresizingMaskIntoConstraints = false
        let bottomtipsContraints : [NSLayoutConstraint] = [
            bottomTips.topAnchor.constraint(equalTo: leftView.centerYAnchor, constant: 10),
            bottomTips.leftAnchor.constraint(equalTo: tipLabel.leftAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(bottomtipsContraints)
        
        rightView.addSubview(shareBtn)
        shareBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shareBtn.leftAnchor.constraint(equalTo: rightView.leftAnchor),
            shareBtn.rightAnchor.constraint(equalTo: rightView.rightAnchor),
            shareBtn.widthAnchor.constraint(equalToConstant: tipSViewH),
            shareBtn.heightAnchor.constraint(equalToConstant: tipSViewH)
            ])
//        rightView.backgroundColor = tc_Color(hex: "#ed5c4d")
        let stackView = UIStackView(arrangedSubviews: [leftView,rightView])
        stackView.alignment = UIStackViewAlignment.fill
        stackView.spacing = 0
        // 子视图分部方式 (枚举值)
        stackView.distribution = UIStackViewDistribution.fill
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor)
            ])
        
        let bottomLine = UIView()
        addSubview(bottomLine)
        bottomLine.backgroundColor = tc_Color(hex: "#808080")
        bottomLine.layer.cornerRadius = 1
        bottomLine.clipsToBounds = true
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomLine.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 2),
            bottomLine.widthAnchor.constraint(equalToConstant: 50)
            ])

    }
}
// MARK:事件响应
extension TrickyTipsView{
    func showTips() {
        timer?.invalidate()
        timer = nil
        self.isHidden = false
        UIView.animate(withDuration: 1) {
            self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: tipSViewH)
        }
        timer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(hiddenTips), userInfo: nil, repeats: false)
    }
    func hiddenTips() {
        timer?.invalidate()
        timer = nil
        UIView.animate(withDuration: 1, animations: {
            self.frame = CGRect(x: 0, y: -tipSViewH, width: UIScreen.main.bounds.width, height: tipSViewH)
        }) { (stop) in
            self.isHidden = true
        }
    }
    func handleSwipeFrom(recognizer:UIPanGestureRecognizer) {
        if recognizer.state == .cancelled || recognizer.state == .ended || recognizer.state == .failed{
            if center.y >= tipSViewH/2 {
                showTips()
            }else{
                hiddenTips()
            }
        }else{
            timer?.invalidate()
            timer = nil
            let translation = recognizer.translation(in: leftView)
            recognizer.setTranslation(CGPoint(x: 0, y: 0), in: leftView)
            let centY = center.y + translation.y
            if centY > tipSViewH/2 {
                recognizer.setTranslation(CGPoint(x: 0, y: 0), in: leftView)
                return
            }
            if centY < -tipSViewH/2 {
                return
            }
            self.center = CGPoint(x: center.x, y: centY)
        }
    }
    
    func shareButtonClick() {
        self.isHidden = true
        self.frame = CGRect(x: 0, y: -tipSViewH, width: UIScreen.main.bounds.width, height: tipSViewH)
        if PhotoLibraryPermissions() == false {
            return
        }
        getNewPhoto { (icon) in
            if icon != nil{
                _ = TrickyShareView.show(icon: icon)
            }
        }
    }
}
// MARK:相册相关
extension TrickyTipsView{
    func openSetting() {
        if UIApplication.shared.canOpenURL(URL(string: UIApplicationOpenSettingsURLString)!) {
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }
    }
    func openSetView() {
//        判断上一次拒绝是多久之前。避免频繁弹窗用户反感 设置为30天后再次弹窗
        if UserDefaults.standard.bool(forKey: "TCScreenShotTools Would Like to Access Your Photos") {
            let lastDate = UserDefaults.standard.value(forKey: "TCScreenShotTools Would Like to Access Your Photos Time") as! NSDate
            if NSDate().timeIntervalSince1970 - lastDate.timeIntervalSince1970<30*24*60*60 {
                return
            }
        }
        let appName = Bundle.main.infoDictionary!["CFBundleName"] ?? "app"
        var title = "\"\(appName)\" Would Like to Access Your Photos"
        var cancelTitle = "Don't Allow"
        var okTitle = "OK"
        let currentLanguage = NSLocale.preferredLanguages.first ?? ""
        if currentLanguage.hasPrefix("zh-Han"){
            title = "\"\(appName)\"想访问您的照片"
            cancelTitle = "不允许"
            okTitle = "好"
        }
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.cancel, handler: { (_) in
            UserDefaults.standard.set(true, forKey: "TCScreenShotTools Would Like to Access Your Photos")
            UserDefaults.standard.set(NSDate(), forKey: "TCScreenShotTools Would Like to Access Your Photos Time")
            UserDefaults.standard.synchronize()
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: okTitle, style: UIAlertActionStyle.default, handler: {[weak self] (action) in
             UserDefaults.standard.set(false, forKey: "TCScreenShotTools Would Like to Access Your Photos")
            UserDefaults.standard.synchronize()
            self?.openSetting()
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    func PhotoLibraryPermissions() -> Bool {
        let library:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if(library == PHAuthorizationStatus.denied || library == PHAuthorizationStatus.restricted){
            openSetView()
            return false
        }else {
            return true
        }
    }
    func getNewPhoto(completion: @escaping (_ result:UIImage?) -> ()) -> () {
        //            申请权限
        PHPhotoLibrary.requestAuthorization { (status) in
            if status != .authorized {
                return
            }
            let smartOptions = PHFetchOptions()
            let collection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,subtype: .albumRegular, options: smartOptions)
            for i in 0..<collection.count{
                //获取出但前相簿内的图片
                let resultsOptions = PHFetchOptions()
                resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                                   ascending: false)]
                resultsOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                       PHAssetMediaType.image.rawValue)
                let c = collection[i]
                let title = TCPlatform.isSimulator ? "Camera Roll" : "Screenshots"
                if c.localizedTitle == title{
                    let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
                    if assetsFetchResult.count == 0{
                        completion(nil)
                    }else{
                        PHImageManager.default().requestImage(for: assetsFetchResult[0],
                                                          targetSize: PHImageManagerMaximumSize , contentMode: .default,
                                                          options: nil, resultHandler: {
                                                            (image, _: [AnyHashable : Any]?) in
                                                            completion(image)
                        })
                    }
                }
            }
        }
    }
}
func tc_Color(hex:String)->UIColor{
    var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) {
        let index = cString.index(cString.startIndex, offsetBy:1)
        cString = cString.substring(from: index)
    }
    
    if (cString.characters.count != 6) {
        return UIColor.red
    }
    
    let rIndex = cString.index(cString.startIndex, offsetBy: 2)
    let rString = cString.substring(to: rIndex)
    let otherString = cString.substring(from: rIndex)
    let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
    let gString = otherString.substring(to: gIndex)
    let bIndex = cString.index(cString.endIndex, offsetBy: -2)
    let bString = cString.substring(from: bIndex)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    Scanner(string: rString).scanHexInt32(&r)
    Scanner(string: gString).scanHexInt32(&g)
    Scanner(string: bString).scanHexInt32(&b)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}
