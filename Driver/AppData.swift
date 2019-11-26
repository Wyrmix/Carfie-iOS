//
//  AppData.swift
//  User
//
//  Created by CSS on 10/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

let AppName = "Carfie Driver"
var deviceTokenString = Constants.string.noDevice
var deviceId = Constants.string.noDevice

/// Base API url for the app. This should eventually get refactored into the networking layer.
var baseUrl: String {
    #if DEBUG
        return "https://stage.carfie.com/"
    #else
        return "https://sapi.carfie.com/"
    #endif
}
