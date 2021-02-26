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
    public var isPost: Bool = false
    public var timeOutInterval: CFTimeInterval = 8.0

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
        var url: String!
        var parameters: Parameters!

        /// 判断是否使用mock接口，使用mock接口就不用做那么多的操作了
        if isMock, let mockURL = self.mockURL,!mockURL.isEmpty {
            url = mockURL
            parameters = self.parameters
        } else {
            /// 可以添加更多逻辑，此处看业务需要
            url = self.url?.addingPercentEncoding(withAllowedCharacters: urlQueryAllowed)
            parameters = self.parameters
        }

        session.sessionConfiguration.timeoutIntervalForRequest = timeOutInterval
        session.request(url, method: isPost ? .post : .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
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

    deinit {
        debugPrint("ZKRURLRequest deinit")
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
