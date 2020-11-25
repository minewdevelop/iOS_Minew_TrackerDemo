//
//  Toast.swift
//  MTTrackerKitDemo
//
//  Created by SACRELEE on 5/15/18.
//  Copyright © 2018 MinewTech. All rights reserved.
//

import UIKit

let width = UIScreen.main.bounds.size.width
let height = UIScreen.main.bounds.size.height

class Toast: NSObject {
    
    static func show(message: String) {
        
        let label = UILabel()
        label.frame = CGRect(x: 30, y: height * 0.8, width: width - 60, height: 50)
        label.backgroundColor = UIColor.black
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = message
        
        let window = UIApplication.shared.delegate!.window!
        window?.addSubview(label)
        UIView.animate(withDuration: 2.5, animations: {
            label.alpha = 0
        }) { (com) in
            label.removeFromSuperview()
        }
    }
}
