//
//  Post.swift
//  weiboDemo
//
//  Created by LinDaobin on 2023/8/15.
//

import SwiftUI

// Data Model
struct Post: Codable, Identifiable
{
    let id: Int
    let avatar: String    // 头像图片名称
    let vip: Bool
    let name: String
    let date: String
    
    var isFollowed: Bool  // 是否关注这条微博的作者
    
    let text: String      // 微博内容
    let images: [String]  //微博图片
    var commentCount: Int // 评论数

    var likeCount: Int    //点赞数
    var isLiked: Bool     // 是否点赞
    
    
}

extension Post: Equatable
{
    static func == (lhs: Self, rhs: Self) -> Bool { return lhs.id == rhs.id }
}

extension Post  // 对于Post的扩展， 对于和数据模型无关的，剥离出来单独写
{
    var commentCountText: String // 评论按钮要显示的文本
    {
        if(commentCount <= 0 ) { return "评论" }
        else if(commentCount <= 1000) { return "\(commentCount)" }
        
        return String(format: "%.1fk", Double(commentCount) / 1000)
    }
    
    var likeCountText: String // 点赞按钮要显示的文本
    {
        if(likeCount <= 0) { return "点赞" }
        else if(likeCount <= 1000) { return "\(likeCount)" }
        
        return String(format: "%.1fk", Double(likeCount) / 1000)
    }
}

struct PostList: Codable
{
    var list: [Post]
}

func loadPostListData(fileName: String) -> PostList
{
    guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else
    {
        fatalError("在mainBundle中无法找到 \(fileName)")
    }
    
    guard let data = try? Data(contentsOf: url) else
    {
        fatalError("无法加载 \(url)")
    }
    
    guard let list = try? JSONDecoder().decode(PostList.self, from: data) else
    {
        fatalError("无法将解析JSON data 解析成 PostList")
    }
    
    return list
}
