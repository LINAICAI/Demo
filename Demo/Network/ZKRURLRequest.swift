//
//  ZKRURLRequest.swift
//  Demo
//
//  Created by LINAICAI on 2021/2/25.
//

import Alamofire
import Foundation
import UIKit

public class ZKRURLRequest {
    public typealias ZKRURLRequestCompletion = (ZKRURLRequest?, Any?, ZKRURLRequestError?) -> Void

    public var url: String?
    public var parameters: [String: Any]?
    public var method: HTTPMethod = .get

    /// 用来在开发环境中快速调用mock接口用的
    /// 若启动mock方式发起调用，ZKRURLRequest将不会对请求的主机域名做任何处理
    public var isMock: Bool = false
    public var mockURL: String?

    public init(_ url: String?, _ parameters: [String: Any]? = nil) {
        self.url = url
        self.parameters = parameters
    }

    private let session = Alamofire.Session(configuration: URLSessionConfiguration.default)

    /// 异步发送请求
    public func sendAsynchronousWithCompletion(completion: ZKRURLRequestCompletion?) {
        guard let url = self.url?.addingPercentEncoding(withAllowedCharacters: urlQueryAllowed) else {
            completion?(self, nil, ZKRURLRequestError(code: .invalidURL))
            return
        }

        session
            .request(url, method: method, parameters: parameters, encoding: URLEncoding.default)
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["application/json"])
            .responseString(completionHandler: { response in
                switch response.result {
                case .success:
                    if let result = response.value {
                        completion?(self, result, nil)
                    } else {
                        completion?(self, nil, ZKRURLRequestError(code: .invalidServerData))
                    }
                case let .failure(error):
                    completion?(self, nil, ZKRURLRequestError(stat: nil, msg: error.errorDescription))
                }

            })
    }
}

public extension ZKRURLRequest {
    /// 在进行URL编码的过程中，部分字符可能被要求不允许参与编码的，需要在这里加入
    private var urlQueryAllowed: CharacterSet {
        var charSet = CharacterSet.urlQueryAllowed
        charSet.insert(charactersIn: "#")
        return charSet
    }
}
