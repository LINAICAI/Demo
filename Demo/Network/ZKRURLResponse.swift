//
//  ZKRURLResponse.swift
//  Demo
//
//  Created by LINAICAI on 2021/2/25.
//

import Foundation
import HandyJSON

public struct ZKRURLResponse<T>: HandyJSON {
    public var stat: String?
    public var msg: String?
    public var data: T?

    public init() {}
}

public extension ZKRURLResponse {
    var isSuccess: Bool {
        if stat == "1" {
            return true
        }
        return false
    }
}
