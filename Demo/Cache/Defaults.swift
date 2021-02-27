//
//  Defaults.swift
//  Demo
//
//  Created by LINAICAI on 2021/2/27.
//

import Foundation
public final class Defaults {
    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    public subscript(key: String) -> Any? {
        get {
            return defaults.value(forKey: key)
        }

        set {
            defaults.set(newValue, forKey: key)
        }
    }
}
