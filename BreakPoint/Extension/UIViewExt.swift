//
//  UIViewExt.swift
//  BreakPoint
//
//  Created by Nan on 2018/3/8.
//  Copyright © 2018年 nan. All rights reserved.
//

import UIKit

extension UIView {
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardWillChange(_ notif: NSNotification) {
        // 取得鍵盤動畫時間
        let duration = notif.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        // 取得鍵盤動畫效果
        let curve = notif.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        // 取得鍵盤開始跟結束的rect 並計算差距
        let beginningFrame = notif.userInfo![UIKeyboardFrameBeginUserInfoKey] as! CGRect
        let endFrame = (notif.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
    }
}
