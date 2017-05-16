//
//  ViewController.swift
//  TCScreenShotToolsExample
//
//  Created by 谈超 on 2017/5/15.
//  Copyright © 2017年 谈超. All rights reserved.
//

import UIKit
import TCScreenShotTools
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let sv = UIStackView(arrangedSubviews: [yellowView,blueView])
        view.addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sv.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sv.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            sv.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            sv.heightAnchor.constraint(equalToConstant: 200)
            ])
        sv.alignment = UIStackViewAlignment.fill
        sv.spacing = 15
        // 子视图分部方式 (枚举值)
        sv.distribution = UIStackViewDistribution.fillEqually
    }
    
    func haha()  {
        if TCPlatform.isSimulator {
            NotificationCenter.default.post(Notification.init(name: NSNotification.Name.UIApplicationUserDidTakeScreenshot))
        }else{
            let alert = UIAlertController(title: "手机用户请使用Home+Power键截屏", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
       
        print(#function)
    }
    lazy var yellowView : UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.red
        view.setTitle("模拟器用户点击截图", for: UIControlState.normal)
        view.titleLabel?.numberOfLines = 0
        view.addTarget(self, action: #selector(haha), for: .touchUpInside)
        return view
    }()
    
    lazy var blueView : UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.blue
        view.setTitle("手机用户使用Home+Power键截屏", for: UIControlState.normal)
        view.titleLabel?.numberOfLines = 0
        view.addTarget(self, action: #selector(haha), for: .touchUpInside)
        return view
    }()
    
//    lazy var purpleView : UIButton = {
//        let view = UIButton()
//        view.backgroundColor = UIColor.purple
//        view.addTarget(self, action: #selector(haha), for: .touchUpInside)
//        return view
//    }()
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

