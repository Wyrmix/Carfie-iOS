//
//  MockServiceConfiguration.swift
//  CoreTests
//
//  Created by Christopher Olsen on 12/6/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct MockServiceConfiguration: ServiceConfiguration {
    var baseUrl: URL {
        return URL(string: "https://umn.com")!
    }
}
