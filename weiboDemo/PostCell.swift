//
//  PostCel.swift
//  weiboDemo
//
//  Created by LinDaobin on 2023/8/15.
//

import SwiftUI

struct PostCell: View
{
    
    let post: Post
    var bindingPost: Post
    {
        userData.post(forId: post.id)!
    }
    
    @State var presentcomment: Bool = false
    @EnvironmentObject var userData: UserData
    
    var body: some View
    {
        var post = bindingPost // 局部post
        return VStack
            {
                //一条微博的上段头像昵称这一水平栏
                HStack(spacing: 5)
                {
                    
                    Image(uiImage: UIImage(named: post.avatar)!)
                        .resizable().scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(PostVIPBadge(vip: post.vip).offset(x: 16, y:16))
                        //.padding(.leading, 0)
                    
                    // 昵称和时间戳
                    VStack(alignment: .leading, spacing: 5)
                    {
                        Text(post.name)
                            .font(Font.system(size: 16))
                            .foregroundColor(Color(red: 242 / 255.0, green: 99 / 255.0, blue: 4 / 255.0))
                            .lineLimit(1)
                        Text(post.date)
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    }.padding(.leading, 10)
                    
                    Spacer()
                    
                    //关注按钮
                    if(!post.isFollowed)
                    {
                        Button(action:{
                            post.isFollowed = true
                            self.userData.update(post)
                            })
                        {
                            Text("关注")
                                .font(.system(size: 14))
                                .foregroundColor(.orange)
                                .frame(width: 50, height: 26)
                                .overlay(RoundedRectangle(cornerRadius: 13).stroke(.orange, lineWidth: 1))
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                }
                
                Text(post.text).font(.system(size: 17))
                
                //图片部分
                if(!post.images.isEmpty)
                {
                    PostImageCell(images: post.images, width: UIScreen.main.bounds.width - 30)
                }
                
                Divider()
                
                //一条微博底部的按钮
                HStack
                {
                    Spacer()
                    PostCellToolbarButton(image: post.isLiked ? "heart.fill" : "heart",
                                          text: post.likeCountText, color: post.isLiked ? .red : .black)
                    {
                        if(post.isLiked)
                        {
                            post.isLiked = false
                            post.likeCount -= 1
                            print("取消点赞")
                        }
                        else
                        {
                            post.isLiked = true
                            post.likeCount += 1
                            print("点赞")
                        }
                        self.userData.update(post)
                    }
                    Spacer()
                    PostCellToolbarButton(image: "message", text: post.commentCountText, color: .black)
                    {
                        self.presentcomment = true
                    }
                    .sheet(isPresented: $presentcomment, content: { CommentInputView(post: post).environmentObject(self.userData) })
                    // 模态推出不属于之前view的子view，所以需要调用环境对象  
                }
                
                Rectangle()  //post底部的水平分割线
                    .padding(.horizontal, -15) // 为了占满屏幕全部宽度
                    .frame(height: 10)
                    .foregroundColor(Color(red: 238 / 255.0, green: 238 / 255.0, blue: 238 / 255.0))
            }
            .padding(.horizontal, 15)
            .padding(.top, 15)
    }
}

struct PostCell_Previews: PreviewProvider
{
    static var previews: some View
    {
        PostCell(post: UserData().recommendPostList.list[0]).environmentObject(UserData())
    }
}
