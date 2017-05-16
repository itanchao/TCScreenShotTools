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
    var shareIcon : UIImage?
    open static let shared: TrickyTipsView = {
        let instance = TrickyTipsView()
        return instance
    }()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: -tipSViewH, width: UIScreen.main.bounds.width, height: tipSViewH))
    }
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: -tipSViewH, width: UIScreen.main.bounds.width, height: tipSViewH))
        self.windowLevel = UIWindowLevelStatusBar
        self.backgroundColor = UIColor.white
        addSubview(shareBtn)
        shareBtn.translatesAutoresizingMaskIntoConstraints = false
        let sharebtnConstraints : [NSLayoutConstraint] = [
            shareBtn.topAnchor.constraint(equalTo: self.topAnchor),
            shareBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            shareBtn.rightAnchor.constraint(equalTo: self.rightAnchor),
            shareBtn.widthAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(sharebtnConstraints)
        addSubview(tipLabel)
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        let tipsLabelConstraints : [NSLayoutConstraint] = [
            tipLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -10),
            tipLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40)
        ]
        NSLayoutConstraint.activate(tipsLabelConstraints)
        addSubview(bottomTips)
        bottomTips.translatesAutoresizingMaskIntoConstraints = false
        let bottomtipsContraints : [NSLayoutConstraint] = [
            bottomTips.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 10),
            bottomTips.leftAnchor.constraint(equalTo: tipLabel.leftAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(bottomtipsContraints)
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
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var timer : Timer?
    
}
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
        UIView.animate(withDuration: 1, animations: {
            self.frame = CGRect(x: 0, y: -tipSViewH, width: UIScreen.main.bounds.width, height: tipSViewH)
        }) { (stop) in
            self.isHidden = true
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
extension TrickyTipsView{
    func PhotoLibraryPermissions() -> Bool {
        let library:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if(library == PHAuthorizationStatus.denied || library == PHAuthorizationStatus.restricted){
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
                if c.localizedTitle == "Screenshots"{
                    let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
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
