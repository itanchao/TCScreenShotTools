//
//  TrickyShareView.swift
//  TCScreenShotTools
//
//  Created by 谈超 on 2017/5/15.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
public enum TrickyShareType:Int {
    case TrickyShareTypeWechat = 0
    case TrickyShareTypeQQ     = 1
    case TrickyShareTypeWechatTimeLine = 2
    case TrickyShareTypeWeibo  = 3
    case TrickyShareTypeQzone  = 4
}
public class TrickyShareView: UIView {
    static func show(icon:UIImage?){
        let shareView = TrickyShareView(frame: UIScreen.main.bounds)
        shareView.shareIcon = icon
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = UIWindowLevelNormal
        window.backgroundColor = UIColor.black
        window.addSubview(shareView)
        window.isHidden = false
        TrickyTipsView.shared.bgWindows.append(window)
        shareView.iconView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 9.0, *) {
            let iconViewConstraints : [NSLayoutConstraint] = [
                shareView.iconView.topAnchor.constraint(equalTo: shareView.titleLabel.bottomAnchor, constant: 16),
                shareView.iconView.centerXAnchor.constraint(equalTo: shareView.centerXAnchor),
                shareView.iconView.widthAnchor.constraint(equalToConstant: shareView.bounds.width*0.7),
                shareView.iconView.heightAnchor.constraint(equalToConstant: shareView.bounds.height*0.7)
            ]
            NSLayoutConstraint.activate(iconViewConstraints)
        } else {
           shareView.addConstraints([
                NSLayoutConstraint(item: shareView.iconView, attribute: .top, relatedBy: .equal, toItem: shareView.titleLabel, attribute: .bottom, multiplier: 1, constant: 14),
                NSLayoutConstraint(item: shareView.iconView, attribute: .centerX, relatedBy: .equal, toItem: shareView, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item:  shareView.iconView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: shareView.bounds.width*0.7),
                NSLayoutConstraint(item:  shareView.iconView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: shareView.bounds.width*0.7)
                ])
        }
        UIView.animate(withDuration: 0.2, animations: {
            shareView.layoutIfNeeded()
        }) { (stop) in
            _ = [shareView.wxBtn,shareView.qqBtn,shareView.pyqBtn,shareView.wbBtn,shareView.qzoneBtn].map({ (button) in
                button.isHidden = false
            })
            _ = shareView.subviews.map({ (subv) in
                subv.isHidden = false
            })
        }
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        buildUI()
    }
    
    /// 关闭当前视图
    func dismiss() {
        // 隐藏其他控件让IconView落到截图之前的View上，形成景深视觉效果
        _ = subviews.map { (subv) in subv.isHidden = subv != iconView }
        UIWindow.animate(withDuration: 0.2, animations: {
            self.iconView.frame = UIScreen.main.bounds
        }) { (stop) in
            self.removeFromSuperview()
        }
    }
    
    /// 分享按钮点击事件
    func shareBtnClick(btn:UIButton) {
         TCScreenShotTools.shared.shareView(self, didClickShareBtn : TrickyShareType.init(rawValue: btn.tag)!, withIcon: shareIcon!)
    }
    var shareIcon : UIImage?{
        didSet{
            iconView.image = shareIcon
        }
    }
    // MARK:懒加载控件
    lazy var sharetips:UILabel = {
        let lbl = UILabel()
        lbl.text = "分享到"
        lbl.backgroundColor = UIColor.white
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textColor = tc_Color(hex: "#8b8b8b")
        lbl.isHidden = true
        return lbl
    }()
    lazy var wxBtn: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.tag = 0
        btn.setBackgroundImage(UIImage.tc_bundleImageNamed(name: "umsocial_wechat.png"), for: .normal)
        btn.addTarget(self, action: #selector(shareBtnClick(btn:)), for: .touchUpInside)
        btn.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 40, height: 40))
        return btn
    }()
    lazy var qqBtn: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.tag = 1
        btn.setImage(UIImage.tc_bundleImageNamed(name: "umsocial_qq.png"), for: .normal)
        btn.addTarget(self, action: #selector(shareBtnClick(btn:)), for: .touchUpInside)
        btn.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 40, height: 40))
        return btn
    }()
    
    lazy var pyqBtn: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.tag = 2
        btn.setImage(UIImage.tc_bundleImageNamed(name: "umsocial_wechat_timeline.png"), for: .normal)
        btn.addTarget(self, action: #selector(shareBtnClick(btn:)), for: .touchUpInside)
        btn.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 40, height: 40))

        return btn
    }()
    
    lazy var wbBtn: UIButton = {
        let btn = UIButton()
        btn.tag = 3
        btn.setImage(UIImage.tc_bundleImageNamed(name: "umsocial_sina.png"), for: .normal)
        btn.addTarget(self, action: #selector(shareBtnClick(btn:)), for: .touchUpInside)
        btn.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 40, height: 40))
        btn.isHidden = true
        return btn
    }()
    
    lazy var qzoneBtn: UIButton = {
        let btn = UIButton()
        btn.tag = 4
        btn.setImage(UIImage.tc_bundleImageNamed(name: "umsocial_qzone.png"), for: .normal)
        btn.addTarget(self, action: #selector(shareBtnClick(btn:)), for: .touchUpInside)
        btn.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 40, height: 40))
        btn.isHidden = true
        return btn
    }()
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "截屏分享"
        lbl.font = UIFont.boldSystemFont(ofSize: 30)
        lbl.textColor = UIColor.black
        lbl.sizeToFit()
        lbl.isHidden = true
        return lbl
    }()
    lazy var iconView = UIImageView(frame: UIScreen.main.bounds)
    lazy var cancelBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(tc_Color(hex: "#ed5c4d"), for: .normal)
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        btn.sizeToFit()
        btn.isHidden = true
        return btn
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    释放当前window
    deinit {
        TrickyTipsView.shared.bgWindows.removeLast()
    }
}

// MARK: - UI搭建
extension TrickyShareView{
    func buildUI() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 9.0, *) {
            let titleLabelConstraints : [NSLayoutConstraint] = [
                titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant:70)
            ]
            NSLayoutConstraint.activate(titleLabelConstraints)
        } else {
            addConstraints([
                NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 70)
            ])
        }
        addSubview(cancelBtn)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 9.0, *) {
            let cancelBtnConstraints : [NSLayoutConstraint] = [
                cancelBtn.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
                cancelBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30)
            ]
            NSLayoutConstraint.activate(cancelBtnConstraints)
        } else {
            addConstraints([
                NSLayoutConstraint(item: cancelBtn, attribute: .bottom, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: cancelBtn, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -30)
                ])
        }
        addSubview(iconView)
        iconView.backgroundColor = UIColor.gray
        let line = UIView()
        addSubview(line)
        line.backgroundColor = tc_Color(hex: "#8b8b8b")
        line.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 9.0, *) {
            let lineConstraints : [NSLayoutConstraint] = [
                line.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50+bounds.height*0.7),
                line.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
                line.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30),
                line.heightAnchor.constraint(equalToConstant: 1)
            ]
            NSLayoutConstraint.activate(lineConstraints)
        } else {
            addConstraints([
                NSLayoutConstraint(item: line, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 50+bounds.height*0.7),
                NSLayoutConstraint(item: line, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 30),
                NSLayoutConstraint(item: line, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -30),
                NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 1)
                ])
        }
        addSubview(sharetips)
        sharetips.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 9.0, *) {
            let sharetipsConstraints : [NSLayoutConstraint] = [
                sharetips.centerYAnchor.constraint(equalTo: line.centerYAnchor),
                sharetips.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                sharetips.widthAnchor.constraint(equalToConstant: 80)
            ]
            NSLayoutConstraint.activate(sharetipsConstraints)

        } else {
            addConstraints([
                NSLayoutConstraint(item: sharetips, attribute: .centerY, relatedBy: .equal, toItem: line, attribute: .centerY, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: sharetips, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: sharetips, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 80),
                
                ])
        }
        let btns = [wxBtn,qqBtn,pyqBtn,wbBtn,qzoneBtn]
        let leftMargin :CGFloat = 20
        let sharH : CGFloat = 40
        let space =  (self.bounds.width - leftMargin * 2 - sharH * 5)/4
        if #available(iOS 9.0, *) {
            let sharebottomView = UIStackView(arrangedSubviews: btns)
            addSubview(sharebottomView)
            sharebottomView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                sharebottomView.leftAnchor.constraint(equalTo: self.leftAnchor,constant:leftMargin),
                sharebottomView.rightAnchor.constraint(equalTo: self.rightAnchor,constant:-leftMargin),
                sharebottomView.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20),
                sharebottomView.heightAnchor.constraint(equalToConstant: sharH)
                ])
            sharebottomView.alignment = UIStackViewAlignment.fill
            sharebottomView.spacing = space
            // 子视图分部方式 (枚举值)
            sharebottomView.distribution = UIStackViewDistribution.fillEqually
        } else {
            for i in 0 ... btns.count-1{
                let btn = btns[i]
                addSubview(btn)
                btn.translatesAutoresizingMaskIntoConstraints = false
                addConstraints([
                NSLayoutConstraint(item: btn, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: leftMargin + (space+sharH) * CGFloat(i)),
                NSLayoutConstraint(item: btn, attribute: .top, relatedBy: .equal, toItem: line, attribute: .bottom, multiplier: 1, constant: 20),
                NSLayoutConstraint(item: btn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: sharH),
                NSLayoutConstraint(item: btn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: sharH)
                    ])
            }
        }
    

    }
}
// MARK: - Bundle资源工具方法
extension Bundle{
    static func tc_myLibraryBundle()->Bundle?{
       return Bundle(url: Bundle.tc_myLibraryBundleURL()!)
    }
    static func tc_myLibraryBundleURL()->URL?{
        let bunndle = Bundle(for: TCScreenShotTools.self)
        return bunndle.url(forResource: "TCScreenShotTools", withExtension: "bundle")
    }
}
extension UIImage{
    static func tc_bundleImageNamed(name:String)->UIImage{
        return tc_imageNamed(name: name, inBundle: Bundle.tc_myLibraryBundle()!)
    }
    static func tc_imageNamed(name:String,inBundle:Bundle)->UIImage{
        let iconName = name.components(separatedBy: ".png").first ?? ""
        if UIScreen.main.bounds.size.height > 1334 {
            if let iconX3 = UIImage(named: "\(iconName)@3x.png", in: inBundle, compatibleWith: nil){
                return iconX3
            }
            if let iconX2 = UIImage(named: "\(iconName)@2x.png", in: inBundle, compatibleWith: nil){
                return iconX2
            }
            return UIImage(named: name, in: inBundle, compatibleWith: nil) ?? UIImage()
        }else{
            if let iconX2 = UIImage(named: "\(iconName)@2x.png", in: inBundle, compatibleWith: nil){
                return iconX2
            }
            if let iconX = UIImage(named: name, in: inBundle, compatibleWith: nil){
                return iconX
            }
            return UIImage(named: "\(iconName)@3x.png", in: inBundle, compatibleWith: nil) ?? UIImage()
        }
    }
}
