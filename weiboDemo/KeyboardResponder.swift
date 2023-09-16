//
//  KeyboardResponder.swift
//  weiboDemo
//
//  Created by LinDaobin on 2023/8/17.
//

//用于对评论编辑界面键盘弹出时，设置键盘高度，得以能够改变编辑界面的按钮位置
//目前系统默认行为已经可以做到，这个文件没有使用

import SwiftUI

class KeyboardResponder: ObservableObject
{
    @Published var keyboardHeight: CGFloat = 0
    
    init()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow( notification: Notification)
    {
        guard let frame = notification.userInfo?[UIWindow.keyboardFrameEndUserInfoKey] as? CGRect else // 尝试转换成CGRect
        {
            return
        }
        
        keyboardHeight = frame.height
    }
    
    @objc private func keyboardWillHide( notification: Notification)
    {
        keyboardHeight = 0
    }
}
