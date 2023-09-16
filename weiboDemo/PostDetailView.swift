//
//  PostDetailView.swift
//  weiboDemo
//
//  Created by LinDaobin on 2023/8/15.
//

import SwiftUI

struct PostDetailView: View
{
    
    let post: Post
    
    var body: some View
    {
        List
        {
            PostCell(post:  post).listRowInsets(EdgeInsets())
            
            ForEach(1...10, id: \.self)
            {
                i in
                Text("评论 \(i)")
            }
        }
        .listStyle(.plain).listStyle(.grouped)
        .navigationBarTitle("", displayMode: .inline)
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(post: UserData().recommendPostList.list[0]).environmentObject(UserData())
    }
}
