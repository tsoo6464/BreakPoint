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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(_ notif: NSNotification) {
        // 取得鍵盤動畫時間
        let duration = notif.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        // 取得鍵盤動畫效果
        let curve = notif.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        // 取得鍵盤開始跟結束的rect 並計算差距
        let beginningFrame = notif.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let endFrame = (notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - beginningFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
    }
}
