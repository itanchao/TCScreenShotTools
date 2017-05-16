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
        let iconViewConstraints : [NSLayoutConstraint] = [
            shareView.iconView.topAnchor.constraint(equalTo: shareView.titleLabel.bottomAnchor, constant: 16),
            shareView.iconView.centerXAnchor.constraint(equalTo: shareView.centerXAnchor),
            shareView.iconView.widthAnchor.constraint(equalToConstant: shareView.bounds.width*0.7),
            shareView.iconView.heightAnchor.constraint(equalToConstant: shareView.bounds.height*0.7)
        ]
        NSLayoutConstraint.activate(iconViewConstraints)
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
        let titleLabelConstraints : [NSLayoutConstraint] = [
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant:70)
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
        addSubview(cancelBtn)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        let cancelBtnConstraints : [NSLayoutConstraint] = [
            cancelBtn.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            cancelBtn.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30)
        ]
        NSLayoutConstraint.activate(cancelBtnConstraints)
        addSubview(iconView)
        iconView.backgroundColor = UIColor.gray
        let line = UIView()
        addSubview(line)
        line.backgroundColor = tc_Color(hex: "#8b8b8b")
        line.translatesAutoresizingMaskIntoConstraints = false
        let lineConstraints : [NSLayoutConstraint] = [
            line.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50+bounds.height*0.7),
            line.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
            line.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30),
            line.heightAnchor.constraint(equalToConstant: 1)
        ]
        NSLayoutConstraint.activate(lineConstraints)
        addSubview(sharetips)
        sharetips.translatesAutoresizingMaskIntoConstraints = false
        let sharetipsConstraints : [NSLayoutConstraint] = [
            sharetips.centerYAnchor.constraint(equalTo: line.centerYAnchor),
            sharetips.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            sharetips.widthAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(sharetipsConstraints)
        let btns = [wxBtn,qqBtn,pyqBtn,wbBtn,qzoneBtn]
        let sharebottomView = UIStackView(arrangedSubviews: btns)
        
        addSubview(sharebottomView)
        sharebottomView.translatesAutoresizingMaskIntoConstraints = false
        let leftMargin :CGFloat = 20
        let sharH : CGFloat = 40
        NSLayoutConstraint.activate([
            sharebottomView.leftAnchor.constraint(equalTo: self.leftAnchor,constant:leftMargin),
            sharebottomView.rightAnchor.constraint(equalTo: self.rightAnchor,constant:-leftMargin),
            sharebottomView.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 20),
            sharebottomView.heightAnchor.constraint(equalToConstant: sharH)
            ])
        sharebottomView.alignment = UIStackViewAlignment.fill
        sharebottomView.spacing = (self.bounds.width - leftMargin * 2 - sharH * 5)/4
        // 子视图分部方式 (枚举值)
        sharebottomView.distribution = UIStackViewDistribution.fillEqually
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
        return UIImage(named: name, in: inBundle, compatibleWith: nil)!
    }
}
