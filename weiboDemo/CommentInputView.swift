//
//  CommentInputView.swift
//  weiboDemo
//
//  Created by LinDaobin on 2023/8/16.
//

import SwiftUI

struct CommentInputView: View
{
    let post: Post
    @State private var text: String = ""
    @State private var showEmptyTextHUD: Bool = false // 是否显示"评论是否为空"的提示语
    @Environment(\.presentationMode) var presentationMode //存储在环境变量中的模态属性
    @EnvironmentObject var userData: UserData
    
    //@ObservedObject private var keyboardResponder: KeyboardResponder = KeyboardResponder()  // 需要初始赋值
    
    var body: some View
    {
        VStack(spacing: 0)
        {
            CommentTextView(text: $text, beginEdittingOnAppear: true)
                .overlay(
                    Text("评论不能为空")
                        .opacity(showEmptyTextHUD ? 1 : 0)
                        .foregroundColor(.gray)
                        .scaleEffect(showEmptyTextHUD ? 1 : 0.5) //缩放，为了配合动画使用
                )
            HStack(spacing: 0)
            {
                Button(action:{
                    self.presentationMode.wrappedValue.dismiss()
                })
                {
                    Text("取消").padding()
                    
                }
                
                Spacer()
                
                Button(action: {
                    if(self.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) // 过滤文字两段空白字符再判断
                    {
                        //.spring动画回弹显示，参数越大回弹越明显 0 ~ 1
                        withAnimation(.spring(dampingFraction: 0.5)) { self.showEmptyTextHUD = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {self.showEmptyTextHUD = false})
                        //1.5秒后隐藏
                        
                        return
                    }
                    var post = self.post
                    post.commentCount += 1
                    self.userData.update(post)
                    print(self.text)
                    self.presentationMode.wrappedValue.dismiss()
                })
                {
                    Text("发送").padding()
                }
            }
            .font(.system(size: 18))
            .foregroundColor(.black)
        }
        //.padding(.bottom, keyboardResponder.keyboardHeight)
    }
}

struct CommentInputView_Previews: PreviewProvider
{
    static var previews: some View
    {
        CommentInputView(post: UserData().recommendPostList.list[0])
    }
}
