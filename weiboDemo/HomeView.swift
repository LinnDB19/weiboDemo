//
//  HomeView.swift
//  weiboDemo
//
//  Created by LinDaobin on 2023/8/16.
//

import SwiftUI

private let kScreenWidth = UIScreen.main.bounds.width

struct HomeView: View
{
    @State var leftPercent: CGFloat = 0 // 0 下划线在左边， 1 下划线在右边

    init()
    {
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View
    {
        NavigationView
        {
            GeometryReader  // 放在这里面能够自动撑开
            {
                geometry in
                HscrollViewController(pageWidth: geometry.size.width, contentSize: CGSize(width: geometry.size.width * 2, height: geometry.size.height), leftPercent: self.$leftPercent, content:{
                        HStack(spacing: 0)
                        {
                            PostListView(category: .RECOMMEND).frame(width: kScreenWidth)
                            PostListView(category: .HOT).frame(width: kScreenWidth)
                        }}
                )
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarItems(leading: HomeNavigationBar(leftPercent: $leftPercent)) // HomeView的leftPercent和HomeNavigationBar内部的绑定
            .navigationBarTitle("首页", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserData())
    }
}
