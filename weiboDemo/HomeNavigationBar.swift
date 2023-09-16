//
//  HomeNavigationBar.swift
//  weiboDemo
//
//  Created by LinDaobin on 2023/8/16.
//

import SwiftUI

private let kLabelWidth: CGFloat = 60
private let kButtonHeight: CGFloat = 24
private let kViewWidth: CGFloat = UIScreen.main.bounds.width * 0.5

struct HomeNavigationBar: View {
    
    // @State 表示 该值是View的一个状态，当属性值改变时，系统会更新一次view
    // @Binding 表示 和外部值绑定
    @Binding var leftPercent: CGFloat // 0 下划线在左边， 1 下划线在右边
    
    var body: some View
    {
        
        HStack(alignment: .top, spacing: 0)
        {
            Button(action: { print("点击相机按钮")})
            {
                Image(systemName: "camera")
                    .resizable()
                    .scaledToFit()
                    .frame(width: kButtonHeight, height: kButtonHeight)
                    .padding(.horizontal, 15)
                    .padding(.top, 5)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            VStack(spacing: 3)
            {
                HStack(spacing: 5)
                {
                    Text("推荐")
                        .bold()
                        .opacity(Double(1 - leftPercent * 0.5)) // 透明度
                        .frame(width: kLabelWidth, height: kButtonHeight)
                        .padding(.top, 5)
                        .onTapGesture { withAnimation { self.leftPercent = 0 } }
                    
                    Spacer()
                    
                    Text("热门")
                        .bold()
                        .opacity(Double(0.5 + leftPercent * 0.5)) // 透明度
                        .frame(width: kLabelWidth, height: kButtonHeight)
                        .padding(.top, 5)
                        .onTapGesture { withAnimation { self.leftPercent = 1 } }
                }
                .font(.system(size: 20))
                
                RoundedRectangle(cornerRadius: 2)
                    .foregroundColor(.orange)
                    .frame(width: 30, height: 4)
                    .offset(x: kViewWidth * (self.leftPercent - 0.5) + kLabelWidth * (0.5 - self.leftPercent))
                // 当leftPercent为0时，kViewWidth * - 0.5 偏移到View的最左边，再加上文字标签的一半就是合适位置
            }
            .frame(width: kViewWidth)
            
            Spacer()
            
            Button(action: { print("点击加号按钮")})
            {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: kButtonHeight, height: kButtonHeight)
                    .padding(.horizontal, 15)
                    .padding(.top, 5)
                    .foregroundColor(.orange)
            }
        }
        .frame(width: UIScreen.main.bounds.width)
    }
}

struct HomeNavigationBar_Previews: PreviewProvider
{
    static var previews: some View
    {
        HomeNavigationBar(leftPercent: .constant(0))
    }
}
