//
//  NetworkManager.swift
//  weiboDemo
//
//  Created by LinDaobin on 2023/8/17.
//

import Foundation
import Alamofire

private let NetworkAPIBaseURL = "https://github.com/xiaoyouxinqing/PostDemo/raw/master/PostDemo/Resources/"
typealias NetworkRequestResult = Result<Data, Error>
typealias NetworkCompletion = (NetworkRequestResult) -> Void

class NetworkManager
{
    //sinleton 单例
    static let shared = NetworkManager()
    var commonHeaders: HTTPHeaders  = ["user_id" : "123", "token" : "xxxxxxx"]
    
    private init() {}
    
    // @escaping 指明闭包 为 逃逸闭包，在函数结束后才调用，生命周期长于函数；@noescaping 闭包在函数结束前调用
    @discardableResult // 返回值可以被忽略
    func requestGet( path: String, parameters: Parameters?, completion: @escaping NetworkCompletion ) -> DataRequest
    {
        return AF.request(NetworkAPIBaseURL + path, parameters: parameters, headers: commonHeaders, requestModifier: {$0.timeoutInterval = 5})
            .responseData
            {
                response in
                switch response.result
                {
                    case let .success(data): completion(.success(data))
                    case let .failure(error): completion(.failure(error))
                }
            }
    }
    
    @discardableResult
    func requestPost(path: String, parameters: Parameters?, completion: @escaping NetworkCompletion) -> DataRequest
    {
        return AF.request(NetworkAPIBaseURL + path, method: .post, parameters: parameters, encoding: JSONEncoding.prettyPrinted,
                          headers: commonHeaders, requestModifier: {$0.timeoutInterval = 5})
                .responseData
                {
                    response in
                    switch response.result
                    {
                        case let .success(data): completion(.success(data))
                        case let .failure(error): completion(.failure(error))
                    }
                }
    }
    
    private func handleError(_ error: AFError) -> NetworkRequestResult
    {
        if let underlyingError = error.underlyingError
        {
            let nserror = underlyingError as NSError
            let code = nserror.code
            if  code == NSURLErrorNotConnectedToInternet ||
                code == NSURLErrorTimedOut ||
                code == NSURLErrorInternationalRoamingOff ||
                code == NSURLErrorDataNotAllowed ||
                code == NSURLErrorCannotFindHost ||
                code == NSURLErrorCannotConnectToHost ||
                code == NSURLErrorNetworkConnectionLost
            {
                var userInfo = nserror.userInfo
                userInfo[NSLocalizedDescriptionKey] = "网络连接有问题";
                      let currentError = NSError(domain: nserror.domain, code: code, userInfo: userInfo)
                return .failure(currentError)
            }
        }
        
        return .failure(error)
    }
}
