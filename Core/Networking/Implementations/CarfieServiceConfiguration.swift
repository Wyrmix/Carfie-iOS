//
//  CarfieServiceConfiguration.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/18/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct CarfieServiceConfiguration: ServiceConfiguration {
    var baseUrlString: String {
        #if DEBUG
            return "https://stage.carfie.com"
        #else
            return "https://sapi.carfie.com"
        #endif
    }
    
    var baseUrl: URL {
        return URL(string: baseUrlString)!
    }
}
