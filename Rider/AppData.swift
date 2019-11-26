//
//  AppData.swift
//  User
//
//  Created by CSS on 10/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

let AppName = "Carfie"
let requestCheckInterval : TimeInterval = 5
var offlineNumber = "57777"
let requestInterval : TimeInterval = 60  // seconds

var baseUrl: String {
    #if DEBUG
        return "https://stage.carfie.com/"
    #else
        return "https://sapi.carfie.com/"
    #endif
}
