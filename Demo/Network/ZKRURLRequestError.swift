//
//  ZKRURLRequestError.swift
//  Demo
//
//  Created by LINAICAI on 2021/2/25.
//

import Foundation
public struct ZKRURLRequestError: Error {
    public var stat: String?
    public var msg: String?

    public enum ErrorCode: String {
        case invalidURL = "非法的URL"
        case invalidServerData = "非法的服务端数据"
    }

    public init(stat: String?, msg: String?) {
        self.stat = stat
        self.msg = msg
    }

    public init(code: ErrorCode) {
        stat = "999"
        msg = code.rawValue
    }
}
