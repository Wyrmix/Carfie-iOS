//
//  CarfieServiceConfiguration.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/18/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct CarfieServiceConfiguration: ServiceConfiguration {
    private var baseUrlString: String {
        #if DEBUG
            return "https://stage.carfie.com"
        #else
            return "https://sapi.carfie.com"
        #endif
    }
    
    var baseUrl: URL {
        return URL(string: baseUrlString)!
    }
    
    var defaultHeaders: HTTPHeaders? {
        return [
            // This XML header needs to be added because most of the service endpoints perform a redirect if the request
            // does not appear to be an AJAX call. ¯\_(ツ)_/¯
            "x-requested-with": "XMLHttpRequest",
            "Content-Type": "application/json"
        ]
    }
}
