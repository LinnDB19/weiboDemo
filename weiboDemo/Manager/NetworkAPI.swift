//
//  NetworkAPI.swift
//  weiboDemo
//
//  Created by LinDaobin on 2023/8/18.
//

import Foundation

typealias ResultClosure = (Result<PostList, Error>) -> Void

class NetworkAPI
{
    static func getRecommendPostList(completion: @escaping ResultClosure)
    {
        return self.getPostListWithPath(path: "PostListData_recommend_1.json", completion: completion)
    }
    
    
    static func getHotPostList(completion: @escaping ResultClosure)
    {
        return self.getPostListWithPath(path: "PostListData_hot_1.json", completion: completion)
    }
    
    static func creatPost(text: String, completion: @escaping (Result<Post, Error>) -> Void)
    {
        NetworkManager.shared.requestPost(path: "createpost", parameters: ["text" : text])
        {
            result in
            switch(result)
            {
                case let .success(data):
                    let parseResult: Result<Post, Error> = self.parseData(data)
                    completion(parseResult)
                case let .failure(error):
                    completion(.failure(error))
            }
        }
    }
    
    
    //内部的查询操作函数
    private static func getPostListWithPath(path: String, completion: @escaping ResultClosure)
    {
        NetworkManager.shared.requestGet(path: path, parameters: nil)
        {
            result in
            switch(result)
            {
                case let .success(data):
                    completion(self.parseData(data))
    
                case let .failure(error):
                    completion(.failure(error))
            }
        }
    }
    
    //将数据解析成JSON文件
    private static func parseData<T: Decodable>(_ data: Data) -> Result<T, Error>
    {
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else
        {
            let error = NSError(domain: "NetworkAPIError", code: 0, userInfo: [NSLocalizedDescriptionKey : "Can not parse data"])
            return .failure(error)
        }
        
        return .success(decodedData)
    }
}
