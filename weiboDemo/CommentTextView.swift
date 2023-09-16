//
//  CommentTextView.swift
//  weiboDemo
//
//  Created by LinDaobin on 2023/8/16.
//

import SwiftUI

struct CommentTextView: UIViewRepresentable
{
    @Binding var text: String
    let beginEdittingOnAppear: Bool   // 是否页面弹出时自动进入编辑模式
    
    func makeUIView(context: Context) -> some UIView
    {
        let view = UITextView()
        view.backgroundColor = .systemGray6
        view.font = .systemFont(ofSize: 18)
        view.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        view.delegate = context.coordinator
        view.text = text
        
        if(beginEdittingOnAppear)
        {
            view.becomeFirstResponder()
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }
    
    class Coordinator: NSObject, UITextViewDelegate
    {
        let parent: CommentTextView
        
        init(parent: CommentTextView)
        {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView)
        {
            parent.text = textView.text
        }
    }
}

struct CommentTextView_Previews: PreviewProvider
{
    static var previews: some View
    {
        CommentTextView(text: .constant(""), beginEdittingOnAppear: true)
    }
}
