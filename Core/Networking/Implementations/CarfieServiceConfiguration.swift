//
//  CarfieServiceConfiguration.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/18/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct CarfieServiceConfiguration: ServiceConfiguration {
    let baseUrlString = "https://sapi.carfie.com"
    
    var baseUrl: URL {
        return URL(string: baseUrlString)!
    }
}
