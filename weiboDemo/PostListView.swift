//
//  PostListView.swift
//  weiboDemo
//
//  Created by LinDaobin on 2023/8/15.
//
// 展示一个列表

import SwiftUI
import BBSwiftUIKit

struct PostListView: View
{
    let category: PostListCategory
    @EnvironmentObject var userData: UserData
    
    var body: some View
    {
        BBTableView(userData.postList(for: category).list) // 参数需要是一个列表类型
        {
            post in
            NavigationLink(destination: PostDetailView(post: post)) // 页面跳转
            {
                PostCell(post: post).listRowInsets(EdgeInsets())
            }.buttonStyle(OriginalButtonStyle())  // 不让列表改变一条微博的样式
        }
        .bb_setupRefreshControl // 下拉刷新展示的文本
        {
            control in
            control.attributedTitle = NSAttributedString(string: "加载中...")
        }
        .bb_pullDownToRefresh(isRefreshing: $userData.isRefreshing)
        {
            self.userData.refreshPostList(for: category)
        }
        .bb_pullUpToLoadMore(bottomSpace: 30)
        {
            self.userData.loadMorePostList(for: category)
        }
        .overlay(
            Text(userData.loadingErrorText)
                .bold()
                .frame(width: 200)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .opacity(0.8)
                )
                .animation(nil)
                .opacity(userData.showLoadingError ? 1 : 0) // 透明度
                .scaleEffect(userData.showLoadingError ? 1 : 0.5) //缩放，为了配合动画使用
                .animation(.spring(dampingFraction: 0.5))
                .animation(.easeInOut)
            
        )
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView
        {
            PostListView(category: .HOT)
        }
    }
}
