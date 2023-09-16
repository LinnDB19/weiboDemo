//
//  UserData.swift
//  weiboDemo
//
//  Created by LinDaobin on 2023/8/16.
//
import Foundation
import Combine

class UserData: ObservableObject
{
    @Published var recommendPostList: PostList = loadPostListData(fileName: "PostListData_recommend_1.json")
    @Published var hotPostList: PostList = loadPostListData(fileName: "PostListData_hot_1.json")
    @Published var isRefreshing: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var loadingError: Error?
    
    private var recommendDic: [Int : Int] = [:] // id, index, [:] 表示空字典
    private var hotPostDic:[Int : Int] = [:]   // id, index
    
    init()
    {
        for i in 0..<recommendPostList.list.count
        {
            let post = recommendPostList.list[i]
            recommendDic[post.id] = i
        }
        
        for i in 0..<hotPostList.list.count
        {
            let post = hotPostList.list[i]
            hotPostDic[post.id] = i
        }
    }
}

extension UserData
{
    var showLoadingError: Bool { loadingError != nil  }
    var loadingErrorText: String { loadingError?.localizedDescription ?? "" }
    
    func postList(for category: PostListCategory) -> PostList
    {
        switch(category)
        {
            case .HOT:
                    return hotPostList
            case .RECOMMEND:
                    return recommendPostList
        }
    }
    
    func refreshPostList(for category: PostListCategory)
    {
        switch(category)
        {
        case .RECOMMEND:
            NetworkAPI.getRecommendPostList
            {
                result in
                switch(result)
                {
                case let .success(list):
                    self.handleRefreshPostList(list, for: category)
                case let.failure(error):
                    self.handleLoadingError(error)
                }
                self.isRefreshing = false
            }
        case.HOT:
            NetworkAPI.getHotPostList
            {
                result in
                switch(result)
                {
                case let .success(list):
                    self.handleRefreshPostList(list, for: category)
                case let.failure(error):
                    self.handleLoadingError(error)
                }
                self.isRefreshing = false
            }
        }
    }
    
    func loadMorePostList(for category: PostListCategory)
    {
        if(isLoadingMore || postList(for: category).list.count > 10) {return}
        isLoadingMore = true
        
        //故意写反试试数据的更新
        switch(category)
        {
        case .RECOMMEND:
            NetworkAPI.getHotPostList(completion: { result in
                switch result
                {
                case let .success(list): self.handleLoadMorePostList(list, for: category)
                case let .failure(error): self.handleLoadingError(error)
                }
                self.isLoadingMore = false
            })
        case .HOT:
            NetworkAPI.getRecommendPostList(completion: { result in
                switch result
                {
                case let .success(list): self.handleLoadMorePostList(list, for: category)
                case let .failure(error): self.handleLoadingError(error)
                }
                self.isLoadingMore = false
            })
        }
    }
    
    private func handleLoadMorePostList(_ list: PostList, for category: PostListCategory)
    {
        switch category{
        case .RECOMMEND:
            for post in list.list
            {
                if recommendDic[post.id] != nil {continue}
                recommendPostList.list.append(post)
                recommendDic[post.id] = recommendPostList.list.count - 1
            }
        case .HOT:
            for post in list.list
            {
                if hotPostDic[post.id] != nil {continue}
                hotPostList.list.append(post)
                hotPostDic[post.id] = hotPostList.list.count - 1
            }
        }
    }
    
    private func handleRefreshPostList(_ list: PostList, for category: PostListCategory)
    {
        var tempList: [Post] = []
        var tempDic: [Int: Int] = [:]
        
        for (index, post) in list.list.enumerated()
        {
            if(tempDic[post.id] != nil) {continue}
            tempList.append(post)
            tempDic[post.id] = index
        }
        
        switch(category)
        {
        case .RECOMMEND:
            recommendPostList.list = tempList
            recommendDic = tempDic
        case .HOT:
            hotPostList.list = tempList
            hotPostDic = tempDic
        }
    }
    
    private func handleLoadingError(_ error: Error)
    {
        loadingError = error
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
        {
            self.loadingError = nil
        }
    }
    
    func post(forId id: Int) -> Post?
    {
        if let index = recommendDic[id]
        {
            return recommendPostList.list[index]
        }
        
        if let index = hotPostDic[id]
        {
            return hotPostList.list[index]
        }
        
        return nil
    }
    
    func update(_ post: Post)
    {
        if let index = recommendDic[post.id]
        {
            recommendPostList.list[index] = post
        }
        
        if let index = hotPostDic[post.id]
        {
            hotPostList.list[index] = post
        }
    }
}

enum PostListCategory
{
    case RECOMMEND
    case HOT
}


