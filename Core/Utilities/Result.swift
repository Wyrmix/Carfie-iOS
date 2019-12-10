//
//  Result.swift
//  Carfie
//
//  Created by Christopher Olsen on 9/22/19.
//  Copyright © 2019 Carfie. All rights reserved.
//


import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
}

extension Result {

    public func resolve() throws -> T {
        switch self {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
}

extension Result: Equatable {
    public static func ==(lhs: Result, rhs: Result) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success), (.failure, .failure):
            return true
        default:
            return false
        }
    }
}
